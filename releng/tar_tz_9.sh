#!/bin/bash
#
#
#  tar --use-compress-program=tar_xz_9.sh
exec xz -9 "$@"
