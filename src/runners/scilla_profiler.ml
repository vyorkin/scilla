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

open Core
open Core_profiler.Std_offline
open Yojson
(* open OUnit2 *)
open Syntax

module Dt = Delta_timer

module Prof = struct
  open Dt

  let main = create ~name:"Scilla_profiler.main"
  let init_server = create ~name:"Scilla_profiler.init_server"
end

let parse_typ_wrapper t =
  match FrontEndParser.parse_type t with
  | Error _ -> failwith (sprintf "scilla_profiler: Invalid type in json: %s\n" t)
  | Ok s -> s

let json_exn_wrapper thunk =
  try
    thunk()
  with
  | Json_error s
  | Basic.Util.Undefined (s, _)
  | Basic.Util.Type_error (s, _)
    -> failwith s
  | e -> failwith (Exn.to_string e)

let json_from_file f =
  let thunk () = Basic.from_file f in
  json_exn_wrapper thunk

let json_from_string s =
  let thunk () = Basic.from_string s in
  json_exn_wrapper thunk

let json_to_assoc j =
  let thunk () = Basic.Util.to_assoc j in
  json_exn_wrapper thunk

let json_member m j =
  let thunk () = Basic.Util.member m j in
  json_exn_wrapper thunk

let json_to_list j =
  let thunk () = Basic.Util.to_list j in
  json_exn_wrapper thunk

let json_to_string j =
  let thunk() = Basic.Util.to_string j in
  json_exn_wrapper thunk

let rec json_to_pb t j =
  match t with
  | MapType (_, vt) ->
      let kvlist = json_to_list j in
      let kvlist' = List.map kvlist ~f:(fun kvj ->
          let kj = json_member "key" kvj in
          let vj = json_member "val" kvj in
          let kpb =  Basic.pretty_to_string kj in
          let vpb = json_to_pb vt vj in
          (kpb, vpb)
        ) in
      Ipcmessage_types.Mval ({m = kvlist' })
  | _ -> Ipcmessage_types.Bval (Bytes.of_string (Basic.pretty_to_string j))

let rec pb_to_json pb =
  match pb with
  | Ipcmessage_types.Mval pbm ->
      `List (
        List.map pbm.m ~f:(fun (k, vpb) ->
            let k'= (json_from_string  k |> json_to_string) in
            `Assoc([("key", `String k'); ("val", pb_to_json vpb)])
          )
      )
  | Ipcmessage_types.Bval s -> json_from_string (Bytes.to_string s)

(* Parse a state JSON file into (fname, ftyp, fval) where fval is protobuf encoded. *)
let json_file_to_state path =
  let j = json_from_file path in

  let svars = List.map (json_to_list j) ~f:(fun sv ->
      let fname = json_member "vname" sv |> json_to_string in
      let ftyp = json_member "type" sv |> json_to_string |> parse_typ_wrapper in
      let fval = json_to_pb ftyp (json_member "value" sv) in
      (fname, ftyp, fval)
    ) in
  svars

let state_to_json s =
  `List (
    List.map s ~f:(fun (fname, ftyp, fval) ->
        `Assoc [
          ("vname", `String fname);
          ("type", `String (pp_typ ftyp));
          ("value", pb_to_json fval);
        ]
      )
  )

(* Initialize mock server state with ~state_json_path. *)
let init_server ~sock_addr ~state_json_path =
  Dt.start Prof.init_server;
  let state = json_file_to_state state_json_path in

  let fields = List.filter_map state ~f:(fun (s, t, _) ->
      if s = ContractUtil.balance_label then None else Some (s, t)) in
  MockIPCClient.initialize ~fields ~sock_addr;
  (* Update the server (via the test client) with the state values we want. *)
  List.iter state ~f:(fun (fname, _, value) ->
      if fname <> ContractUtil.balance_label
      then MockIPCClient.update ~fname ~value
      else ()
    );
  (* Find the balance from state and return it. *)
  let res = match List.find state ~f:(fun (fname, _, _) -> fname = ContractUtil.balance_label) with
    | Some (_, _, balpb) ->
        (match balpb with
         | Ipcmessage_types.Bval (bal) -> (json_from_string (Bytes.to_string bal) |> json_to_string)
         | _ -> failwith ("Incorrect type of " ^ ContractUtil.balance_label ^ " in state.json"))
    | None -> failwith ("Unable to find " ^ ContractUtil.balance_label ^ " in state.json") in
  Dt.stop Prof.init_server;
  res

type env =
  { bin_dir : string;
    tests_dir : string;
    stdlib_dir : string;
    sock_addr : string;
  }

let mk_env ~sock_addr =
  let bin_dir = Sys.getcwd () ^/ "bin" in
  let tests_dir = Sys.getcwd () ^/ "tests" in
  let stdlib_dir = Sys.getcwd() ^/ "src" ^/ "stdlib" in
  { bin_dir; tests_dir; stdlib_dir; sock_addr }

let run_test env name i =
  GlobalConfig.set_validate_json false;
  let open ScillaUtil.FilePathInfix in
  let istr = Int.to_string i in
  let contract_dir = env.tests_dir ^/ "contracts" in
  let dir = env.tests_dir ^/ "runner" ^/ name in
  let tmp_dir = Filename.temp_dir_name in
  let output_file = tmp_dir ^/ name ^ "_output_" ^ istr ^. "json" in
  let state_json_path = dir ^/ "state_" ^ istr ^. "json" in
  let balance = init_server ~sock_addr:env.sock_addr ~state_json_path in
  let input_message = dir ^/ "message_" ^ istr ^. "json" in
  let input_blockchain = dir ^/ "blockchain_" ^ istr ^. "json" in
  let input = contract_dir ^/ name ^. "scilla" in
  let cli : Cli.ioFiles =
    { input_init = dir ^/ "init.json";
      input_state = "";
      input_message;
      input_blockchain;
      output = output_file;
      input;
      libdirs = [env.stdlib_dir];
      gas_limit = Stdint.Uint64.of_int 8000;
      balance = Stdint.Uint128.of_string balance;
      pp_json = true;
      ipc_address = env.sock_addr;
    } in
  Scilla_runner.run cli

let run_tests env contract_name i n =
  let ixs = List.range i n in
  List.iter ixs ~f:(fun i -> run_test env contract_name i)

let cmd =
  Command.basic
    ~summary:"Run Scilla profiler"
    Command.Let_syntax.(
      let%map_open
        sock_addr = flag "-s" (required string)
          ~doc:"Socket address for IPC communication with blockchain for state access"
      and contract_name = flag "-c" (required string)
          ~doc:"Contract name to use for profiling"
      and i = flag "-i" (optional_with_default 1 int)
          ~doc:"Index of the initial contract step"
      and n = flag "-n" (required int)
          ~doc:"Total number of steps to execute"
      and t = flag "-t" (optional_with_default 100 int)
          ~doc:"How many times to run contract steps"
      in fun () ->
        let env = mk_env ~sock_addr in
        for _i = 1 to t do
          run_tests env contract_name i n
        done)

let () =
  Command.run ~version:"0.1.0" ~build_info:"Scilla profiler" cmd
