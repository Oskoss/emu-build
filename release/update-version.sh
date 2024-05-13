#!/bin/bash
set -eux

echo "Today is " `date -u --date=@1404372514`

echo "Updating version to " `cat /workspace/cur_version`

gcloud storage cp /workspace/cur_version gs://eq2emu-devn00b-hash/version

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!                 Version Updated                    !!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
