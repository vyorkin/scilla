
(* This file was auto-generated based on "src/lang/base/ParserFaults.messages". *)

(* Please note that the function [message] can raise [Not_found]. *)

let message =
  fun s ->
    match s with
    | 0 ->
        "Contract modules begin by specifying a scilla version number (e.g. 'scilla_version 0') instead of 'with'.\n"
    | 1 ->
        "After 'scilla_version' a numeric literal (e.g. 0) is expected rather than 'with'.\n"
    | 2 ->
        "After specifying a scilla version number, either imports, a library or contract is expected.\n"
    | 192 ->
        "Following the library definition, a contract is expected.\n"
    | 193 ->
        "When a contract is being defined a valid identifier is expected, in this case 'with' is an invalid name.\n"
    | 194 ->
        "After a contract has been named, the parser expects a left parenthesis not 'with'.\n"
    | 195 ->
        "After the contract has been named and the left parenthesis entered the parser expects the immutable fields declaration. 'with' is an invalid name for an immutable field.\n"
    | 204 ->
        "After the defintion of no immutable fields, either the mutable fields definition, a transition or procedure is expected. 'field', 'transition' or 'procedure' is expected, not 'with'.\n"
    | 212 ->
        "Transitions must begin with a valid name, not 'with'.\n"
    | 215 ->
        "After a transition has been named, a left parenthesis in necessary where we are specifying the transition parameters rather than 'with'.\n"
    | 216 ->
        "The transition parameter name is invalid.\n"
    | 219 ->
        "After a transition has the parameters defined, we expect a semi-colon seperated list of statements in the body instead of 'with'.\n"
    | 270 ->
        "Syntax parsing error.\n"
    | 281 ->
        "Following a transition defintion, the parser expects a transition or a procedure or end of file. 'with' is none of the aforementioned items.\n"
    | 274 ->
        "Following a procedure definition, the parser expects a transition or a procedure or end of file. 'with' is none of the aforementioned items.\n"
    | 275 ->
        "After a procedure has been named, the parser expects the arguments to be defined so there should\nbe a left parenthesis instead of 'with'.\n"
    | 276 ->
        "In the transition body the parser expects a list of semi-colon seperated statements, those\nstatements cannot begin with 'with'.\n"
    | 205 ->
        "For a mutable field declaration, the parser expects a valid name.\n"
    | 206 ->
        "In a mutable field declaration, following the naming, a colon preceding the type is expected rather than 'with'.\n"
    | 207 ->
        "In a mutable field declaration, following the colon after the naming, a type is expected rather than 'with', a keyword.\n"
    | 208 ->
        "In a mutable field declaration, after the type is specified an equals is expected instead of 'with'.\n"
    | 209 ->
        "In a mutable field declaration, it is expected that the field is initalised to be equal to some expression rather than 'with', a keyword.\n"
    | 283 ->
        "Syntax parsing error.\n"
    | 196 ->
        "In a immutable field decleration, the parser expects a colon following the name not 'with'.\n"
    | 197 ->
        "In an immutable field declaration the parser expects a valid type name. 'with' is an invalid type name, being a keyword.\n"
    | 198 ->
        "Following the declaration of an immutable field, the parser expects another one seperated by a comma or the end of the declarations with a right parenthesis. 'with' is neither of the two but a keyword.\n"
    | 201 ->
        "Following a comma in the list of immutable fields, the parser expects another field name, colon and a type not 'with'.\n"
    | 289 ->
        "Expression terms cannot begin with 'with', a keyword.\n"
    | 82 ->
        "Type functions expect a type id, 'with' is not a valid type id but rather a keyword.\n"
    | 83 ->
        "Type functions following the type id, expect an arrow not the keyword 'with'.\n"
    | 84 ->
        "Type functions following their type id and arrow, expect an expression. 'with' is a keyword.\n"
    | 291 ->
        "Syntax parsing error.\n"
    | 155 ->
        "Syntax parsing error.\n"
    | 147 ->
        "Syntax parsing error.\n"
    | 144 ->
        "Syntax parsing error.\n"
    | 145 ->
        "Syntax parsing error.\n"
    | 87 ->
        "Syntax parsing error.\n"
    | 93 ->
        "Syntax parsing error.\n"
    | 94 ->
        "Syntax parsing error.\n"
    | 107 ->
        "Syntax parsing error.\n"
    | 108 ->
        "Syntax parsing error.\n"
    | 182 ->
        "Syntax parsing error.\n"
    | 105 ->
        "Syntax parsing error.\n"
    | 97 ->
        "Syntax parsing error.\n"
    | 99 ->
        "Syntax parsing error.\n"
    | 100 ->
        "Syntax parsing error.\n"
    | 92 ->
        "Syntax parsing error.\n"
    | 109 ->
        "Syntax parsing error.\n"
    | 110 ->
        "Syntax parsing error.\n"
    | 111 ->
        "Syntax parsing error.\n"
    | 169 ->
        "Syntax parsing error.\n"
    | 170 ->
        "Syntax parsing error.\n"
    | 172 ->
        "Syntax parsing error.\n"
    | 173 ->
        "Syntax parsing error.\n"
    | 175 ->
        "Syntax parsing error.\n"
    | 176 ->
        "Syntax parsing error.\n"
    | 177 ->
        "Syntax parsing error.\n"
    | 112 ->
        "Syntax parsing error.\n"
    | 113 ->
        "Syntax parsing error.\n"
    | 114 ->
        "Syntax parsing error.\n"
    | 124 ->
        "Syntax parsing error.\n"
    | 125 ->
        "Syntax parsing error.\n"
    | 119 ->
        "Syntax parsing error.\n"
    | 129 ->
        "Syntax parsing error.\n"
    | 130 ->
        "Syntax parsing error.\n"
    | 131 ->
        "Syntax parsing error.\n"
    | 132 ->
        "Syntax parsing error.\n"
    | 133 ->
        "Syntax parsing error.\n"
    | 134 ->
        "Syntax parsing error.\n"
    | 135 ->
        "Syntax parsing error.\n"
    | 116 ->
        "Syntax parsing error.\n"
    | 117 ->
        "Syntax parsing error.\n"
    | 136 ->
        "Syntax parsing error.\n"
    | 137 ->
        "Syntax parsing error.\n"
    | 157 ->
        "Syntax parsing error.\n"
    | 158 ->
        "Syntax parsing error.\n"
    | 159 ->
        "Syntax parsing error.\n"
    | 161 ->
        "Syntax parsing error.\n"
    | 138 ->
        "Syntax parsing error.\n"
    | 139 ->
        "Syntax parsing error.\n"
    | 141 ->
        "Syntax parsing error.\n"
    | 151 ->
        "Syntax parsing error.\n"
    | 152 ->
        "Syntax parsing error.\n"
    | 73 ->
        "Syntax parsing error.\n"
    | 293 ->
        "Syntax parsing error.\n"
    | 11 ->
        "Syntax parsing error.\n"
    | 12 ->
        "Syntax parsing error.\n"
    | 13 ->
        "Syntax parsing error.\n"
    | 14 ->
        "Syntax parsing error.\n"
    | 15 ->
        "Syntax parsing error.\n"
    | 16 ->
        "Syntax parsing error.\n"
    | 17 ->
        "Syntax parsing error.\n"
    | 18 ->
        "Syntax parsing error.\n"
    | 76 ->
        "Syntax parsing error.\n"
    | 79 ->
        "Syntax parsing error.\n"
    | 80 ->
        "Syntax parsing error.\n"
    | 81 ->
        "Syntax parsing error.\n"
    | 190 ->
        "Syntax parsing error.\n"
    | 187 ->
        "Syntax parsing error.\n"
    | 296 ->
        "Syntax parsing error.\n"
    | 3 ->
        "Syntax parsing error.\n"
    | 295 ->
        "Syntax parsing error.\n"
    | 4 ->
        "Syntax parsing error.\n"
    | 5 ->
        "Syntax parsing error.\n"
    | 8 ->
        "Syntax parsing error.\n"
    | 298 ->
        "Syntax parsing error.\n"
    | 220 ->
        "Syntax parsing error.\n"
    | 260 ->
        "Syntax parsing error.\n"
    | 300 ->
        "Syntax parsing error.\n"
    | 223 ->
        "Syntax parsing error.\n"
    | 89 ->
        "Syntax parsing error.\n"
    | 90 ->
        "Syntax parsing error.\n"
    | 225 ->
        "Syntax parsing error.\n"
    | 227 ->
        "Syntax parsing error.\n"
    | 228 ->
        "Syntax parsing error.\n"
    | 229 ->
        "Syntax parsing error.\n"
    | 230 ->
        "Syntax parsing error.\n"
    | 266 ->
        "Syntax parsing error.\n"
    | 226 ->
        "Syntax parsing error.\n"
    | 231 ->
        "Syntax parsing error.\n"
    | 162 ->
        "Syntax parsing error.\n"
    | 232 ->
        "Syntax parsing error.\n"
    | 233 ->
        "Syntax parsing error.\n"
    | 240 ->
        "Syntax parsing error.\n"
    | 250 ->
        "Syntax parsing error.\n"
    | 251 ->
        "Syntax parsing error.\n"
    | 235 ->
        "Syntax parsing error.\n"
    | 237 ->
        "Syntax parsing error.\n"
    | 238 ->
        "Syntax parsing error.\n"
    | 242 ->
        "Syntax parsing error.\n"
    | 243 ->
        "Syntax parsing error.\n"
    | 245 ->
        "Syntax parsing error.\n"
    | 248 ->
        "Syntax parsing error.\n"
    | 253 ->
        "Syntax parsing error.\n"
    | 255 ->
        "Syntax parsing error.\n"
    | 256 ->
        "Syntax parsing error.\n"
    | 262 ->
        "Syntax parsing error.\n"
    | 259 ->
        "Syntax parsing error.\n"
    | 302 ->
        "Syntax parsing error.\n"
    | 304 ->
        "Syntax parsing error.\n"
    | 62 ->
        "Syntax parsing error.\n"
    | 63 ->
        "Syntax parsing error.\n"
    | 54 ->
        "Syntax parsing error.\n"
    | 21 ->
        "Syntax parsing error.\n"
    | 25 ->
        "Syntax parsing error.\n"
    | 55 ->
        "Syntax parsing error.\n"
    | 28 ->
        "Syntax parsing error.\n"
    | 29 ->
        "Syntax parsing error.\n"
    | 30 ->
        "Syntax parsing error.\n"
    | 31 ->
        "Syntax parsing error.\n"
    | 32 ->
        "Syntax parsing error.\n"
    | 45 ->
        "Syntax parsing error.\n"
    | 47 ->
        "Syntax parsing error.\n"
    | 48 ->
        "Syntax parsing error.\n"
    | 36 ->
        "Syntax parsing error.\n"
    | 33 ->
        "Syntax parsing error.\n"
    | 34 ->
        "Syntax parsing error.\n"
    | 37 ->
        "Syntax parsing error.\n"
    | 38 ->
        "Syntax parsing error.\n"
    | 41 ->
        "Syntax parsing error.\n"
    | 57 ->
        "Syntax parsing error.\n"
    | 69 ->
        "Syntax parsing error.\n"
    | 58 ->
        "Syntax parsing error.\n"
    | 59 ->
        "Syntax parsing error.\n"
    | 60 ->
        "Syntax parsing error.\n"
    | 61 ->
        "Syntax parsing error.\n"
    | 22 ->
        "Syntax parsing error.\n"
    | 64 ->
        "Syntax parsing error.\n"
    | 65 ->
        "Syntax parsing error.\n"
    | 23 ->
        "Syntax parsing error.\n"
    | 20 ->
        "Syntax parsing error.\n"
    | 27 ->
        "Syntax parsing error.\n"
    | 52 ->
        "Syntax parsing error.\n"
    | 71 ->
        "Syntax parsing error.\n"
    | _ ->
        raise Not_found
