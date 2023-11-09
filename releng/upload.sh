#!/bin/bash
#
#	upload.sh path/to/largefile.tar.xz
#
#
#


# TOKEN=$(gcloud auth print-access-token)
TOKEN=${TOKEN:="TOKEN-MISSING"}

# gs://tinytapeout-public-REMOVED/tinytapeout-05/
BUCKET_NAME=${BUCKET_NAME="tinytapeout-public-REMOVED"}
OBJECT_PATH=${OBJECT_PATH="tinytapeout-05/"}

FILENAME=$(basename "$1")

MIME_TYPE="application/x-xz"

CURL_OPTS="-v"

curl $CURL_OPTS -X POST -T "$1" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: $MIME_TYPE" \
    "https://storage.googleapis.com/upload/storage/v1/b/$BUCKET_NAME/o?uploadType=media&name=${OBJECT_PATH}${FILENAME}"
