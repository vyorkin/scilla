{ stdenv, fetchFromGitHub, buildOcaml, ppx_deriving_protobuf }:

buildOcaml rec {
  name = "protoc";
  version = "1.2.0";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "mransan";
    repo = "ocaml-${name}";
    rev = "60d2d4dd55f73830e1bed603cc44d3420430632c";
    sha256 = "1d1p8ch723z2qa9azmmnhbcpwxbpzk3imh1cgkjjq4p5jwzj8amj";
  };

  installPhase = ''
    mkdir -p tmp/bin
    export PREFIX=`pwd`/tmp
    make all.install.build
    make check_install
    make lib.install
    make bin.install
  '';

  buildInputs = [ ppx_deriving_protobuf ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mransan/ocaml-protoc";
    description = "A Protobuf Compiler for OCaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
