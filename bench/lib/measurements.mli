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
open Core_bench

(** Save benchmark measurements. *)
val save : Measurement.t list -> env:Env.t -> unit

(** Load measurements for the specified [timestamp].
    If the [timestamp] is not given then the latest (previous)
    measurements will be loaded (if any). *)
val load
  :  timestamp:string option
  -> env:Env.t
  -> Measurement.t list option

(** Analyze benchmark measurements. *)
val analyze : Measurement.t list -> Analysis_result.t list

(** Compare the [orig_meas] and [curr_meas],
    return [B.Measurement.t list] containing deltas. *)
val calc_deltas
   : orig_meas:Measurement.t list
  -> curr_meas:Measurement.t list
  -> Measurement.t list
