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




module Tests = TestUtil.DiffBasedTests(
  struct
    let gold_path dir f = [dir; "parser"; "bad"; "gold"; f ^ ".gold" ]
    let test_path f = ["parser"; "bad"; f]
    let runner = "scilla-checker"
    let custom_args = ["-contractinfo"]
    let additional_libdirs = []
    let tests = [
      "cmodule-with.scilla";
      "cmodule-version-number-with.scilla";
      "cmodule-version-number-contract-with.scilla";
      "cmodule-version-number-library-name.scilla";
      "cmodule-version-with.scilla";
      "cmodule-version-number-contract-name-lapren-rparen-with.scilla";
      "cmodule-version-number-contract-name-lparen-with.scilla";
      "cmodule-version-number-contract-name-with.scilla";
      "cmodule-version-number-contract-with.scilla";
      "cmodule-transition-with.scilla";
      "cmodule-transition-id-with.scilla";
      "cmodule-transition-id-lparen-with.scilla";
      "cmodule-transition-id-lparen-rparen-with.scilla";
      "cmodule-transition-id-lparen-rparen-end-with.scilla";
      "cmodule-procedure-with.scilla";
      "cmodule-procedure-id-lparen-rparen-with.scilla";
      "cmodule-field-with.scilla";
      "cmodule-field-id-with.scilla";
      "cmodule-field-id-colon-tid.scilla";
      "cmodule-field-id-colon-tid-eq-with.scilla";
      "cmodule-contract-cid-lparen-id-with.scilla";
      "cmodule-contract-cid-lparen-id-colon-with.scilla";
      "cmodule-contract-cid-lparen-id-colon-comma-with.scilla";
    ]
    let exit_code : Unix.process_status = WEXITED 1
  end)


module LibTests = TestUtil.DiffBasedTests(
  struct
    let gold_path dir f = [dir; "parser"; "bad"; "gold"; f ^ ".gold" ]
    let test_path f = ["parser"; "bad"; f]
    let runner = "scilla-checker"
    let custom_args = []
    let additional_libdirs = [["parser"; "bad"; "lib"]]
    let tests = [
    ]
    let exit_code : Unix.process_status = WEXITED 1
  end)
