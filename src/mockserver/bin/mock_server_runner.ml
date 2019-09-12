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

let run ~sock_addr ~num_pending_requests =
  print_endline @@ "Starting IPC mock server on " ^ sock_addr;
  MockIPCServer.start ~sock_addr ~num_pending_requests;
  ignore @@ In_channel.input_char In_channel.stdin;
  print_endline @@ "Stopping the server...";
  MockIPCServer.stop ~sock_addr;
  print_endline @@ "Bye"

let cmd =
  Command.basic
    ~summary:"Run Scilla IPC mock server"
    Command.Let_syntax.(
      let%map_open
        sock_addr = flag "-s" (required string)
          ~doc:"Socket address for IPC communication with blockchain for state access"
      and num_pending_requests = flag "-n" (optional_with_default 5 int)
          ~doc:"Maximum number of pending requests"
      in fun () -> run ~sock_addr ~num_pending_requests)

let () =
  Command.run ~version:"0.1.0" ~build_info:"Scilla mock IPC server" cmd
