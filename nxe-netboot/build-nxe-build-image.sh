export PATH=${coreutils}/bin:${sed}/bin
mkdir -p $out/bin
sed "s|RELEASE_NIX_PLACEHOLDER|${nixpkgs}/nixos/release.nix|" $src > $out/bin/nxe-build-image
chmod +x $out/bin/nxe-build-image
