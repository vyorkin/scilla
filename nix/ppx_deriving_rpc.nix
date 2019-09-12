{ stdenv, fetchFromGitHub, buildDunePackage, rpclib, rresult, result, ppxfind, ppx_tools, ppx_deriving, cppo }:

buildDunePackage rec {
  pname = "ppx_deriving_rpc";

  inherit (rpclib) version src;

  buildInputs = [ rpclib ppx_tools ppx_deriving ppxfind cppo ];

  propagatedBuildInputs = [ result rresult ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mirage/ocaml-rpc";
    description = "Ppx deriver for ocaml-rpc";
    license = licenses.isc;
    maintainers = [ maintainers.vyorkin ];
  };
}
