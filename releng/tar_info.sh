#!/bin/bash -e
#
#
# tar ... --new-volume-script=tar_info.sh --multi-volume --tape-length=512M ...
#
LOGFILE=tar_info.log

echo "===" >> $LOGFILE
date >> $LOGFILE
echo "$0" "$*" >> $LOGFILE

for varname in "TAR_VERSION" \
	"TAR_ARCHIVE" \
	"TAR_BLOCKING_FACTOR" \
	"TAR_VOLUME" \
	"TAR_FORMAT" \
	"TAR_SUBCOMMAND" \
	"TAR_FD"
do
	echo "${varname}=${!varname}" >> $LOGFILE
done

if [ -f "$TAR_ARCHIVE" ]
then
	tar_volume=$(expr "$TAR_VOLUME" - 1)
	seq=$(printf "%02d" "$tar_volume")
	newfile=$(echo -n "$TAR_ARCHIVE" | sed -e "s#NNN#${seq}#")
	echo "Rename $TAR_ARCHIVE => $newfile"
	if [ -f "$newfile" ]
	then
		echo "$0: $newfile: exists" 1>&2
		exit 1
	fi
	ls -l "$TAR_ARCHIVE"
	mv -f "$TAR_ARCHIVE" "$newfile"
	ls -l "$newfile"
	xz -9v "$newfile"
else
	echo "$0: $TAR_ARCHIVE: file does not exist" 1>&2
	exit 1
fi
