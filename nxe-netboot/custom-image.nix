# nix expression for custom netboot image
{ pkgs ? import <nixpkgs> {} }:
let
  nixpkgs = pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "17.09";
      sha256 = "0kpx4h9p1lhjbn1gsil111swa62hmjs9g93xmsavfiki910s73sh";
  };

in rec {

  build-pxe-image = { customModules ? [] }:
    let 
      versionSuffix = "test";
      versionModule = {
        system.nixosVersionSuffix = versionSuffix;
        system.nixosRevision = nixpkgs.rev or nixpkgs.shortRev;
      };

      build = (import "${nixpkgs}/nixos/lib/eval-config.nix" {
        system = "x86_64-linux";
        modules = [
          (builtins.toPath "${nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix")
          versionModule
        ] ++ customModules;
      }).config.system.build;
    in
      pkgs.symlinkJoin {
        name="netboot";
        paths=[
          build.netbootRamdisk
          build.kernel
          build.netbootIpxeScript
        ];
        postBuild = ''
          mkdir -p $out/nix-support
          echo "file bzImage $out/bzImage" >> $out/nix-support/hydra-build-products
          echo "file initrd $out/initrd" >> $out/nix-support/hydra-build-products
          echo "file ipxe $out/netboot.ipxe" >> $out/nix-support/hydra-build-products
        '';
      };

  nxe-build-image = derivation {
    name = "nxe-build-image";
    src = ./nxe-build-image-template;
    nixfile = ./custom-image.nix;
    coreutils = pkgs.coreutils;
    gnused = pkgs.gnused;
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./nxe-build-image-builder.sh ];
    system = builtins.currentSystem;
  };

}
