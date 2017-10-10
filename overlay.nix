self: super:
let
  nxe-netboot = import ./nxe-netboot/custom-image.nix { pkgs = super; };

  lib = {
    build-pxe-image = nxe-netboot.build-pxe-image;
  };

  tools = {
    nxe-build-image = nxe-netboot.nxe-build-image;
  };

  nxe = {
    inherit 
      tools
      lib;
  };

in
{
  nxe = nxe;
}
