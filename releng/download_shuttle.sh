#!/bin/bash -e
#
#
#	The method:
#
#
#	mkdir data
#	cd data
#	../download_shuttle.sh --download
#	mv downloaded/ ..
#	cp ../downloaded/shuttle_index.json .
#
#	## FIXME spaces in workflow names next time
#	find -name _and			## "build and deploy pages"
#	cd project_dir_commitid/
#	diff -urN _and/ _pages/		## confirm identical set
#	diff -urN _and/ _deployment/
#	diff -urN _and/ _build/
#	mv _and build_and_deploy_pages
#
#	time find . -mindepth 1 -type f -not -name "SHA256SUM.txt" -exec sha256sum {} \; | tee SHA256SUM.txt
#
#	cd ..
#	## This shows up the extent of duplicate files
#	sort data/SHA256SUM.txt > SHA256SUM.txt.sorted
#	time hardlink -c -n -v data 2>&1 | tee HARDLINK.LOG
#	## remove -n to run deduplication for real
#
#	find data -exec chmod g-w -c {} \;
#
#	find data -maxdepth 1 -not -path "./filelist.txt" -printf "%P\n" | sort > filelist.txt
#	# reorder for shuttle_index.json SHA256SUM.txt files at the top
#
#	mkdir tar && cd tar
#	mv ../data/filelist.txt TinyTapeout05-project-artifacts.tar.xz.txt
#
#	tar -cvf TinyTapeout05-project-artifacts.tar.xz --numeric-owner --no-acls --no-selinux --no-xattrs \
#		--sort=name --use-compress-program=../tar_xz_9.sh -C ../data \
#		--files-from=filelist.txt > TAR.LOG 2>&1 &
#	mv TAR.LOG TinyTapeout05-project-artifacts.tar.xz.txt
#
#	../upload.sh "TinyTapeout05-project-artifacts.tar.xz.txt"
#	../upload.sh "TinyTapeout05-project-artifacts.tar.xz"
#
#

if [ -f "shuttle_index.json" ]
then
	SHUTTLE_INDEX_FILE=${SHUTTLE_INDEX_FILE-"shuttle_index.json"}
fi

download_url="https://github.com/TinyTapeout/tinytapeout-05/releases/download/tapeout-ci2311/shuttle_index.zip"
do_download=0
if [ $# -gt 0 ]
then
	case "$1" in
	--download)	do_download=1
			;;
	*)		echo "$0: unknown option $1" 1>&2
			exit 1
			;;
	esac
	shift
fi

if [ -f "$SHUTTLE_INDEX_FILE" ]
then
	echo "File: $SHUTTLE_INDEX_FILE"
fi

if [ $do_download -gt 0 ]
then
	[ -d downloaded ] || mkdir -p downloaded
	if wget -q -O downloaded/shuttle_index.zip "$download_url"
	then
		unzip -lv downloaded/shuttle_index.zip		# validate
		unzip -q -o -d downloaded downloaded/shuttle_index.zip shuttle_index.json
		SHUTTLE_INDEX_FILE="downloaded/shuttle_index.json"
	fi
fi

items=$(jq -r '.mux | keys | .[]' "$SHUTTLE_INDEX_FILE")

for id in ${items}
do
	gh_url=$(  jq -r ".mux[\"$id\"].repo"   $SHUTTLE_INDEX_FILE)
	commitid=$(jq -r ".mux[\"$id\"].commit" $SHUTTLE_INDEX_FILE)

	gh_user_repo=$(echo -n "$gh_url" | sed -e 's#https://github.com/##')

	echo ./download.sh "$gh_user_repo $commitid"
	set +e
	# This is going to error if something is missing or not found
	./download.sh "$gh_user_repo" "$commitid"
	rv=$?
	set -e
	if [ $rv -ne 0 ]
	then
		echo "ERROR[$id]: $gh_user_repo $commitid"
	else
		echo "SUCCESS[$id]: $gh_user_repo $commitid"
	fi
	
	du -s -h .
done
