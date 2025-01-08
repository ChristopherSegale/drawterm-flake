{
  description = "Remotely access a 9Front cpu server";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:/numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      name = "drawterm";
      version = "d7620e8d528a87a3d6cf7285a839d52d4f705771";
      inherit (pkgs.stdenv) mkDerivation;
      inherit (pkgs) fetchgit;
    in {
      packages.default = mkDerivation {
        inherit name version;
        src = fetchgit {
          name = "drawterm-devel";
          url = "git://git.9front.org/plan9front/drawterm";
          rev = version;
          hash = "sha256-v84kvlLKUGR6SY+DPD9fVUivkE56txrMU0dlph2c7bM=";
        };
        CONF="unix";
        buildInputs = with pkgs; [ xorg.libX11 xorg.libXt ];
        installPhase = ''
                          mkdir -p $out/bin
                          cp drawterm $out/bin
                       '';
      };
      packages.meta.license = pkgs.lib.licenses.mit;
    });
}
