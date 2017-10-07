# nix expression for custom netboot image
{ pkgs ? import <nixpkgs> {} }:
let
  image = pkgs.netboot;
  coreutils = pkgs.coreutils;
  sed = pkgs.gnused;
in rec {
  nixpkgs = derivation {
    name = "nixpkgs";
    src = pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "17.09";
      sha256 = "0kpx4h9p1lhjbn1gsil111swa62hmjs9g93xmsavfiki910s73sh";
    };
    inherit coreutils;
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./build-nixpkgs.sh ];
    system = builtins.currentSystem;
  };

  nxe-build-image = derivation {
    name = "nxe-build-image";
    src = ./nxe-build-image-template;
    inherit coreutils sed nixpkgs;
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./build-nxe-build-image.sh ];
    system = builtins.currentSystem;
  };
}
  
