PATH=${gnused}/bin:${coreutils}/bin

mkdir -p ${out}/bin

cp ${nixfile} ${out}/custom-image.nix
sed "s|{{NIX_FILE}}|${out}/custom-image.nix|" ${src} > ${out}/bin/nxe-build-image

chmod +x ${out}/bin/nxe-build-image


