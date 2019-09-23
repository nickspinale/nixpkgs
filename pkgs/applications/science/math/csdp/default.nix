{ lib, stdenv, fetchurl, blas, gfortran, liblapack }:

stdenv.mkDerivation {
  name = "csdp-6.1.1";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Csdp/Csdp-6.1.1.tgz";
    sha256 = "1f9ql6cjy2gwiyc51ylfan24v1ca9sjajxkbhszlds1lqmma8n05";
  };

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ blas (gfortran.nativeDrv or gfortran).cc.lib liblapack ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local/bin $out/bin
  '';

  preInstall = ''
    rm -f INSTALL
    mkdir -p $out/bin
  '';

  meta = {
    homepage = https://projects.coin-or.org/Csdp;
    license = lib.licenses.cpl10;
    maintainers = [ lib.maintainers.roconnor ];
    description = "A C Library for Semidefinite Programming";
    platforms = stdenv.lib.platforms.unix;
  };
}
