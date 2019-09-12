(*
  This file is part of scilla.

  Copyright (c) 2018 - present Zilliqa Research Pvt. Ltd.

  scilla is free software: you can redistribute it and/or modify it under the
  terms of the GNU General Public License as published by the Free Software
  Foundation, either version 3 of the License, or (at your option) any later
  version.

  scilla is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
  A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along with
  scilla.  If not, see <http://www.gnu.org/licenses/>.
*)


open Syntax
open Core
open Core_profiler.Std_offline
open ErrorUtils
open Eval
open DebugMessage
open ContractUtil
open PrettyPrinters
open Stdint
open RunnerUtil
open GlobalConfig

module PG = Timer.Group

(* Profiler groups *)
let pg = PG.create ~name:"scilla_runner"

let pg_local = PG.create ~name:"local mode"
let pg_ipc = PG.create ~name:"ipc mode"

(* Profiler probes *)
let p_parse_lib_b = PG.add_probe pg ~name:"parse-lib-b" ()
let p_parse_lib_e = PG.add_probe pg ~name:"parse-lib-e" ()

let p_parse_contract_b = PG.add_probe pg ~name:"parse-contract-b" ()
let p_parse_contract_e = PG.add_probe pg ~name:"parse-contract-e" ()

let p_check_libs_b = PG.add_probe pg ~name:"check-libs-b" ()
let p_check_libs_e = PG.add_probe pg ~name:"check-libs-e" ()

let p_gas_remaining_b = PG.add_probe pg ~name:"gas-remaining-b" ()
let p_gas_remaining_e = PG.add_probe pg ~name:"gas-remaining-e" ()

let p_deploy_lib_b = PG.add_probe pg ~name:"deploy-lib-b" ()
let p_deploy_lib_e = PG.add_probe pg ~name:"deploy-lib-e" ()

let p_get_initargs_b = PG.add_probe pg ~name:"get-initargs-b" ()
let p_get_initargs_e = PG.add_probe pg ~name:"get-initargs-e" ()

let p_get_state_b = PG.add_probe pg ~name:"get-state-b" ()
let p_get_state_e = PG.add_probe pg ~name:"get-state-e" ()

let p_get_message_b = PG.add_probe pg ~name:"get-message-b" ()
let p_get_message_e = PG.add_probe pg ~name:"get-message-e" ()

(* Local probes *)

let p_handle_msg_local_b = PG.add_probe pg_local ~name:"handle-msg-local-b" ()
let p_handle_msg_local_e = PG.add_probe pg_local ~name:"handle-msg-local-e" ()

(* IPC probes *)

let p_init_store_b = PG.add_probe pg_ipc ~name:"init-store-b" ()
let p_init_store_e = PG.add_probe pg_ipc ~name:"init-store-e" ()

let p_handle_msg_ipc_b = PG.add_probe pg_ipc ~name:"handle-msg-ipc-b" ()
let p_handle_msg_ipc_e = PG.add_probe pg_ipc ~name:"handle-msg-ipc-e" ()

(****************************************************)
(*          Checking initialized libraries          *)
(****************************************************)

let check_libs clibs elibs name gas_limit =
  Timer.record p_check_libs_b;
  let ls = init_libraries clibs elibs in
  (* Are libraries ok? *)
  let res = match ls Eval.init_gas_kont gas_limit with
  | Ok (res, gas_remaining) ->
      plog (sprintf
        "\n[Initializing libraries]:\n%s\n\nLibraries for [%s] are on. All seems fine so far!\n\n"
        (* (Env.pp res) *)
        (String.concat ~sep:", " (List.map (List.rev res) ~f:fst))
        name);
     gas_remaining
  | Error (err, gas_remaining) ->
     fatal_error_gas err gas_remaining
  in
  Timer.record p_check_libs_e;
  res

(****************************************************)
(*     Checking initialized contract state          *)
(****************************************************)
let check_extract_cstate name res gas_limit =
  match res Eval.init_gas_kont gas_limit with
  | Error (err, remaining_gas) ->
      fatal_error_gas err remaining_gas
  | Ok ((_, cstate, field_vals), remaining_gas) ->
      plog (sprintf "[Initializing %s's fields]\nSuccess!\n"
         name );
      cstate, remaining_gas, field_vals

(*****************************************************)
(*   Running the simularion and printing results     *)
(*****************************************************)

let check_after_step res gas_limit  =
  match res Eval.init_gas_kont gas_limit with
  | Error (err, remaining_gas) -> fatal_error_gas err remaining_gas
  | Ok ((cstate, outs, events, accepted_b), remaining_gas) ->
      plog (sprintf "Success! Here's what we got:\n" ^
            (* sprintf "%s" (ContractState.pp cstate) ^ *)
            sprintf "Emitted messages:\n%s\n\n" (pp_literal_list outs) ^
            sprintf"Gas remaining:%s\n" (Uint64.to_string remaining_gas) ^
            sprintf "Emitted events:\n%s\n\n" (pp_literal_list events));
       (cstate, outs, events, accepted_b), remaining_gas

(* Parse the input state json and extract out _balance separately *)
let input_state_json filename =
  let open JSON.ContractState in
  let states = get_json_data filename in
  let match_balance ((vname : string), _) : bool = vname = balance_label in
  let bal_lit = match List.find states ~f:match_balance with
    | Some (_, lit) -> lit
    | None -> raise (mk_invalid_json (balance_label ^ " field missing"))
  in
  let bal_int = match bal_lit with
    | UintLit (Uint128L x) -> x
    | _ -> raise (mk_invalid_json (balance_label ^ " invalid"))
  in
  let no_bal_states = List.filter  states ~f:(fun c -> not @@ match_balance c) in
     no_bal_states, bal_int

(* Add balance to output json and print it out *)
let output_state_json balance field_vals =
  let ballit = (balance_label, UintLit (Uint128L balance)) in
  let concatlist = List.cons ballit field_vals in
    JSON.ContractState.state_to_json concatlist;;

let output_message_json gas_remaining mlist =
  match mlist with
  | [one_message] ->
    (match one_message with
     | Msg m ->
        JSON.Message.message_to_json m
     | _ -> `Null
    )
  | [] -> `Null
  | _ ->
    fatal_error_gas (mk_error0 "Sending more than one message not currently permitted") gas_remaining


let rec output_event_json elist =
  match elist with
  | e :: rest ->
    let j = output_event_json rest in
    (match e with
    | Msg m' ->
      let ej = JSON.Event.event_to_json m' in
      ej :: j
    | _ -> `Null :: j)
  | [] -> []

let deploy_library (cli : Cli.ioFiles) gas_remaining =
  Timer.record p_deploy_lib_b;
  Timer.record p_parse_lib_b;
  let parse_lmodule =
    FrontEndParser.parse_file ScillaParser.Incremental.lmodule cli.input in
  Timer.record p_parse_lib_e;
  match parse_lmodule with
  | Error e ->
    (* Error is printed by the parser. *)
    plog (sprintf "%s\n" "Failed to parse input library file.");
    fatal_error_gas e gas_remaining
  | Ok lmod ->
      plog (sprintf "\n[Parsing]:\nLibrary module [%s] is successfully parsed.\n" cli.input);
      (* Parse external libraries. *)
      let lib_dirs = (FilePath.dirname cli.input :: cli.libdirs) in
      StdlibTracker.add_stdlib_dirs lib_dirs;
      let elibs = import_libs lmod.elibs (Some cli.input_init) in
      (* Contract library. *)
      let clibs = Some (lmod.libs) in

      (* Checking initialized libraries! *)
      let gas_remaining' = check_libs clibs elibs cli.input gas_remaining in

      (* Retrieve initial parameters *)
      let initargs =
        try
          JSON.ContractState.get_json_data cli.input_init
        with
        | Invalid_json s ->
            fatal_error_gas (s @ (mk_error0 (sprintf "Failed to parse json %s:\n" cli.input_init))) gas_remaining'
      in
      (* init.json for libraries can only have _extlibs field. *)
      (match initargs with
      | [(label, _)] when label = extlibs_label -> ()
      | _ -> perr @@ scilla_error_gas_string gas_remaining'
            (mk_error0 (sprintf "Invalid initialization file %s for library\n" cli.input_init))
      );

      let output_json = `Assoc [
        "gas_remaining", `String (Uint64.to_string gas_remaining');
        (* ("warnings", (scilla_warning_to_json (get_warnings ()))) *)
      ] in
        Out_channel.with_file cli.output ~f:(fun channel ->
          if cli.pp_json then
            Yojson.pretty_to_string output_json |> Out_channel.output_string channel
          else
            Yojson.to_string output_json |> Out_channel.output_string channel
          );
  Timer.record p_deploy_lib_e

let run (cli : Cli.ioFiles) =
  PG.reset Eval.pg;
  PG.reset RunnerUtil.pg;
  PG.reset pg;
  PG.reset pg_local;
  PG.reset pg_ipc;
  let is_deployment = (cli.input_message = "") in
  let is_ipc = cli.ipc_address <> "" in
  let is_library =
    (FilePath.get_extension cli.input = GlobalConfig.StdlibTracker.file_extn_library) in

  Timer.record p_gas_remaining_b;
  let gas_remaining =
    let open Unix in
    (* Subtract gas based on (contract+init) size / message size. *)
    if is_deployment then
      let cost' = Int64.add (stat cli.input).st_size (stat cli.input_init).st_size in
      let cost = Uint64.of_int64 cost' in
      if (Uint64.compare cli.gas_limit cost) < 0 then
        fatal_error_gas (mk_error0 (sprintf "Ran out of gas when parsing contract/init files.\n"))  Uint64.zero
      else
        Uint64.sub cli.gas_limit cost
    else
      let cost = Uint64.of_int64 (stat cli.input_message).st_size in
      (* libraries can only be deployed, not "run". *)
      if is_deployment then
        fatal_error_gas (mk_error0 (sprintf "Cannot run a library contract. They can only be deployed\n")) Uint64.zero
      else if (Uint64.compare cli.gas_limit cost) < 0 then
        fatal_error_gas (mk_error0 (sprintf "Ran out of gas when parsing message.\n")) Uint64.zero
      else
        Uint64.sub cli.gas_limit cost
  in
  Timer.record p_gas_remaining_e;

  if is_library then deploy_library cli gas_remaining  else

  Timer.record p_parse_contract_b;
  let parse_module =
    FrontEndParser.parse_file ScillaParser.Incremental.cmodule cli.input in
  Timer.record p_parse_contract_e;

  match parse_module with
  | Error e ->
    (* Error is printed by the parser. *)
    plog (sprintf "%s\n" "Failed to parse input file.");
    fatal_error_gas e gas_remaining
  | Ok cmod ->
      plog (sprintf "\n[Parsing]:\nContract module [%s] is successfully parsed.\n" cli.input);

      (* Parse external libraries. *)
      let lib_dirs = (FilePath.dirname cli.input :: cli.libdirs) in
      StdlibTracker.add_stdlib_dirs lib_dirs;
      let elibs = import_libs cmod.elibs (Some cli.input_init) in
      (* Contract library. *)
      let clibs = cmod.libs in

      (* Checking initialized libraries! *)
      let gas_remaining = check_libs clibs elibs cli.input gas_remaining in

      (* Retrieve initial parameters *)
      Timer.record p_get_initargs_b;
      let initargs =
        try
          JSON.ContractState.get_json_data cli.input_init
        with
        | Invalid_json s ->
            fatal_error_gas
              (s @ (mk_error0 (sprintf "Failed to parse json %s:\n" cli.input_init)))
            gas_remaining
      in
      Timer.record p_get_initargs_e;

      (* Check for version mismatch. Subtract penalty for mist-match. *)
      let emsg, rgas = (mk_error0 ("Scilla version mismatch\n")),
        (Uint64.sub gas_remaining (Uint64.of_int Gas.version_mismatch_penalty))
      in
      let init_json_scilla_version = List.fold_left initargs ~init:None ~f:(fun found (name, lit) ->
        if is_some found then found else
        if name = ContractUtil.scilla_version_label
        then match lit with | UintLit(Uint32L v) -> Some v | _ -> None
        else None
      ) in
      let _ =
        match init_json_scilla_version with
        | Some ijv ->
          let (mver, _, _) = scilla_version in
          let ijv' = Uint32.to_int ijv in
          if ijv' <> mver || mver <> cmod.smver
          then fatal_error_gas emsg rgas
        | None -> fatal_error_gas emsg rgas
      in

      (* Retrieve block chain state  *)
      Timer.record p_get_state_b;
      let bstate =
      try
        JSON.BlockChainState.get_json_data cli.input_blockchain
      with
        | Invalid_json s ->
           fatal_error_gas
              (s @ (mk_error0 (sprintf "Failed to parse json %s:\n" cli.input_blockchain)))
            gas_remaining
      in
      Timer.record p_get_state_e;

      let (output_msg_json, output_state_json, output_events_json, accepted_b), gas =
      if is_deployment
      then
        (* Initializing the contract's state, just for checking things. *)
        let init_res = init_module cmod initargs [] Uint128.zero bstate elibs in
        (* Prints stats after the initialization and returns the initial state *)
        (* Will throw an exception if unsuccessful. *)
        let (cstate', remaining_gas', field_vals) = check_extract_cstate cli.input init_res gas_remaining in

        (* If the data store is not local, we must update the store with the initial field values.
         * Refer to the details comments at [Initialization of StateService]. *)
        Timer.record p_init_store_b;
        if is_ipc then (
          let open StateService in
          let open MonadUtil in
          let open Result.Let_syntax in
          (* We push all fields except _balance. *)
          let fields = List.filter_map cstate'.fields ~f:(fun (s, t) ->
            if s = balance_label then None else
            Some { fname = s; ftyp = t; fval = None })
          in
          let sm = IPC (cli.ipc_address) in
          let () = initialize ~sm ~fields in
          match
             (* TODO: Move gas accounting for initialization here? It's currently inside init_module. *)
             let%bind _ = mapM field_vals ~f:(fun (s, v) ->
              update ~fname:(asId s) ~keys:[] ~value:v
             ) in
             finalize ()
          with
          | Error s -> fatal_error_gas s remaining_gas'
          | Ok _ -> ()
        );
        Timer.record p_init_store_e;

        (* In IPC mode, we don't need to output an initial state as it will be updated directly. *)
        let field_vals' = if is_ipc then [] else field_vals in

        (plog (sprintf "\nContract initialized successfully\n");
          (`Null, output_state_json cstate'.balance field_vals', `List [], false), remaining_gas')
      else
        (* Not initialization, execute transition specified in the message *)
        let () = Timer.record p_get_message_b in
        (let mmsg =
        try
          JSON.Message.get_json_data cli.input_message
        with
        | Invalid_json s ->
            fatal_error_gas
              (s @ (mk_error0 (sprintf "Failed to parse json %s:\n" cli.input_message)))
            gas_remaining
        in
        Timer.record p_get_message_e;
        let m = Msg mmsg in

        let cstate, gas_remaining' =
        if is_ipc then
          let () = Timer.record p_handle_msg_ipc_b in
          let cur_bal = cli.balance in
          let init_res = init_module cmod initargs [] cur_bal bstate elibs in
          let cstate, gas_remaining', _ = check_extract_cstate cli.input init_res gas_remaining in
          (* Initialize the state server. *)
          let fields = List.filter_map cstate.fields ~f:(fun (s, t) ->
            let open StateService in
            if s = balance_label then None else Some { fname = s; ftyp = t; fval = None }
          ) in
          let () = StateService.initialize ~sm:(IPC cli.ipc_address) ~fields in
          Timer.record p_handle_msg_ipc_e;
          (cstate, gas_remaining')
        else

          let () = Timer.record p_handle_msg_local_b in
          (* Retrieve state variables *)
          let (curargs, cur_bal) =
          try
            input_state_json cli.input_state
          with
          | Invalid_json s ->
              fatal_error_gas
                (s @ (mk_error0 (sprintf "Failed to parse json %s:\n" cli.input_state)))
              gas_remaining
          in

          (* Initializing the contract's state *)
          let init_res = init_module cmod initargs curargs cur_bal bstate elibs in
          (* Prints stats after the initialization and returns the initial state *)
          (* Will throw an exception if unsuccessful. *)
          let cstate, gas_remaining', field_vals = check_extract_cstate cli.input init_res gas_remaining in

          (* Initialize the state server. *)
          let fields = List.map field_vals ~f:(fun (s, l) ->
            let open StateService in
            let t = List.Assoc.find_exn cstate.fields ~equal:(=) s in
            { fname = s; ftyp = t; fval = Some l }
          ) in
          let () = StateService.initialize ~sm:Local ~fields in
          Timer.record p_handle_msg_local_e;
          (cstate, gas_remaining')
        in

        (* Contract code *)
        let ctr = cmod.contr in

        plog (sprintf "Executing message:\n%s\n" (JSON.Message.message_to_jstring mmsg));
        plog (sprintf "In a Blockchain State:\n%s\n" (pp_literal_map bstate));
        let step_result = handle_message ctr cstate bstate m in
        let (cstate', mlist, elist, accepted_b), gas =
          check_after_step step_result gas_remaining' in

        (* If we're using a local state (JSON file) then need to fetch and dump it. *)
        let field_vals =
          if is_ipc then [] else
            match StateService.get_full_state (), StateService.finalize() with
            | Ok fv, Ok () -> fv
            | _ -> fatal_error_gas (mk_error0 "Error finalizing state from StateService") gas
        in

        let osj = output_state_json cstate'.balance field_vals in
        let omj = output_message_json gas mlist in
        let oej = `List (output_event_json elist) in
          (omj, osj, oej, accepted_b), gas)
      in
      let output_json = `Assoc [
        ("scilla_major_version", `String (Int.to_string cmod.smver));
        "gas_remaining", `String (Uint64.to_string gas);
        ContractUtil.accepted_label, `String (Bool.to_string accepted_b);
        ("message", output_msg_json);
        ("states", output_state_json);
        ("events", output_events_json);
        (* ("warnings", (scilla_warning_to_json (get_warnings ()))) *)
      ] in
        Out_channel.with_file cli.output ~f:(fun channel ->
          if cli.pp_json then
            Yojson.Basic.pretty_to_string output_json |> Out_channel.output_string channel
          else
            Yojson.Basic.to_string output_json |> Out_channel.output_string channel
          )


(* let () =
 *   let cli = Cli.parse () in
 *   run cli *)
