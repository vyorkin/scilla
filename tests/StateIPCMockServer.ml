open StateIPCIdl

module StateIPCMockServer = IPCIdl(Idl.GenServer ())



(* let fetch_state_value ~query =
  

let update_state_value ~query ~value = *)

(* 
let start_server ~json_path =
  let initial_state = JSON.ContractState.get_json_data json_path in
  curr_state := initial_state;

  IPCServer.fetchStateValue fetch_state_value;
  IPCServer.updateStateValue update_state_value; *)