export PATH=${coreutils}/bin
mkdir -p $out
# Copy all files across - need the tail command to stop
# copying of current or parent directory
for item in $( ls -a $src | tail -n +3); do
	cp -r ${src}/${item} ${out}/${item}
done
