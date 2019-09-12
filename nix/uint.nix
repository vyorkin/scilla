{ stdenv, fetchFromGitHub, buildDunePackage, stdint }:

buildDunePackage rec {
  pname = "uint";
  version = "2.0.1";
  # version = "1.2.1";

  minimumSupportedOcamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "andrenth";
    repo = "ocaml-${pname}";
    rev = "ed1cf57d60e817a473deaebe80d66229653f084d";
    sha256 = "042qd0p59bkj99ggx8zc020zdg0f93w17wv0n80j78i314ra08zd";
    # for 1.2.1
    # rev = "0dc0a310b6c4abe16825f78e3b4d237241879302";
    # sha256 = "0bynms18w9yjaj0vbpvx2asj2g0zgk9axffwh51m8a4fh6q5zw0v";
  };

  buildInputs = [ stdint ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/andrenth/ocaml-uint";
    description = "An unsigned integer library (deprecated)";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
