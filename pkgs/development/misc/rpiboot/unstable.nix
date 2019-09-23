{ stdenv, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation {
  pname = "rpiboot-unstable";
  version = "2019-07-16";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = "ecb8797287853acd0ac2ced40258f23a8990ceae";
    sha256 = "0akwfwps8cdn7y4zmilbr1zvhxyp1h8yidzafg8qirhh5f9x0mf4";
  };

  nativeBuildInputs = [ libusb1 ];

  patchPhase = ''
    sed -i "s@/usr/@$out/@g" main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/rpiboot
    cp rpiboot $out/bin
    cp -r msd $out/share/rpiboot
  '';

  meta = {
    homepage = https://github.com/raspberrypi/usbboot;
    description = "Utility to boot a Raspberry Pi CM/CM3/Zero over USB";
    maintainers = [ stdenv.lib.maintainers.cartr ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
