{ stdenv, fetchFromGitHub, buildDunePackage, cppo, ppx_tools, ppx_deriving
, ppxfind, opaline }:

buildDunePackage rec {
  pname = "ppx_deriving_protobuf";
  version = "master";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = "abd17e3d9fe7310ec6007c772c925586e0dc9eba";
    sha256 = "0aq4f3gbkhhai0c8i5mcw2kpqy8l610f4dknwkrxh0nsizwbwryn";
  };

  buildInputs = [ cppo ppx_tools ppxfind ppx_deriving ];

  # doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/ocaml-ppx/ppx_deriving_protobuf";
    description = "A Protocol Buffers codec generator for OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
