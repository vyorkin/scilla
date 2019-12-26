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

open Core_bench.Bench

(** Load benchmarks *)
val load
  :  params:Params.t
  -> cfg:Config_t.config
  -> env:Env.t
  -> Test.t list

(** Output benchmark groups along with their tests *)
val list : Test.t list -> unit

(** Run the given benchmarks *)
val exec : Test.t list -> params:Params.t -> env:Env.t -> unit