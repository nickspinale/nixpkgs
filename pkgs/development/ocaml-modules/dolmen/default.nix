{ stdenv, fetchFromGitHub, ocaml, findlib, dune, opaline, menhir }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-dolmen-${version}";
	version = "0.4.1";
	src = fetchFromGitHub {
		owner = "Gbury";
		repo = "dolmen";
		rev = "v${version}";
		sha256 = "1hk4i12ldax6gxsgjzp6f0lzgln0wmghqxk2mkc7blq0ra0fmb7l";
	};

	buildInputs = [ ocaml findlib dune opaline ];
	propagatedBuildInputs = [ menhir ];

   installPhase = ''
     opaline -bindir $out/bin -sharedir $out/share -libdir $out/lib/ocaml/${ocaml.version}/site-lib
   '';

	meta = {
		description = "An OCaml library providing clean and flexible parsers for input languages";
		license = stdenv.lib.licenses.bsd2;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
