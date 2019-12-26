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

open Core_bench
open Core_bench.Simplified_benchmark

(** Print the benchmark groups along with their tests *)
val print_tests : Test.t list -> unit

(** Print benchmark results *)
val print_results : Result.t list -> unit

(** Print previous and current benchmark
    results along with their deltas *)
val print_comparison
  :  previous:(Result.t list * string)
  -> current:(Result.t list * string)
  -> deltas:Result.t list
  -> unit
