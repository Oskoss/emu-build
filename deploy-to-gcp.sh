#!/bin/bash
set -eux

echo "Today is " `date -u --date=@1404372514`

echo "Deploying to project $PROJECT_ID"
echo "Using Github Access Token $GITHUB_ACCESS_TOKEN"

sed -i "s#/PROJECT_ID/#/$PROJECT_ID/#g" cloud-build.yaml

gcloud secrets create GITHUB_ACCESS_TOKEN
printf "$GITHUB_ACCESS_TOKEN" | gcloud secrets versions add GITHUB_ACCESS_TOKEN --data-file=-

gcloud builds triggers import --source=cloud-build.yaml