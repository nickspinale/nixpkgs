{ stdenv, lib, fetchFromGitHub, autoreconfHook, libewf, afflib, openssl, zlib
, javaBindings ? false, buildEnv, fetchMavenArtifact, jdk, ant
}:

let

  deps = buildEnv {
    name = "ivy-env";
    pathsToLink = [ "/share/java" ];
    paths = [

      (fetchMavenArtifact {
        groupId = "com.googlecode.java-diff-utils";
        artifactId = "diffutils";
        version = "1.2.1";
        sha256 = "0wf1la6jsibrynrfsp2a7g2gx6f9q44v30qarm9m6x6xp31rg1n9";
      })

      (fetchMavenArtifact {
        groupId = "org.xerial";
        artifactId = "sqlite-jdbc";
        version = "3.8.11";
        sha256 = "13fyy8dlp58d9650cahyk5vs05f2wlbvp66cxv57xmid2gng4dhf";
      })

      (fetchMavenArtifact {
        groupId = "org.postgresql";
        artifactId = "postgresql";
        version = "9.4.1211.jre7";
        sha256 = "15ms7jq62j4qh4qqgnz18ci80sdgl3bsvim4k5p9fz5jnm5fq5zz";
      })

      (fetchMavenArtifact {
        groupId = "com.mchange";
        artifactId = "c3p0";
        version = "0.9.5";
        sha256 = "0gsg0m7g8ivmgzhh6r9ggh99bqil5rn786sg0f5j9yvrnv9rxpld";
      })

      (fetchMavenArtifact {
        groupId = "com.zaxxer";
        artifactId = "SparseBitSet";
        version = "1.1";
        sha256 = "13pdjibgnb5rl9xbi66lgcpcv3fm4n8viy32ydgp0kxwv5vd6d9z";
      })

    ];
  };

in
stdenv.mkDerivation rec {
  version = "4.6.5";
  pname = "sleuthkit";

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = "${pname}-${version}";
    sha256 = "1q1cdixnfv9v4qlzza8xwdsyvq1vdw6gjgkd41yc1d57ldp1qm0c";
  };

  postPatch = ''
    substituteInPlace tsk/img/ewf.c --replace libewf_handle_read_random libewf_handle_read_buffer_at_offset
  '' + lib.optionalString javaBindings ''
    substituteInPlace bindings/java/build.xml --replace /usr/share/java ${deps}/share/java
  '';

  configureFlags = lib.optional javaBindings "--enable-offline";

  preBuild = lib.optionalString javaBindings ''
    mkdir -p $TMP/.ant/lib
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libewf afflib openssl zlib ] ++ lib.optionals javaBindings [ jdk ant ];

  # Hack to fix the RPATH.
  preFixup = "rm -rf */.libs";

  meta = {
    description = "A forensic/data recovery tool";
    homepage = https://www.sleuthkit.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.ipl10;
    inherit version;
  };
}
