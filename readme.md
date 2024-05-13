# Deploy Release Pipeline to GCP

1. Ensure gCloud CLI is installed and `gcloud auth login` is successful.
1. Set `PROJECT_ID` to the correct GCP project you wish to deploy to.
1. Set `GITHUB_ACCESS_TOKEN` to the correct Github Access Token where releases will be created.
1. Run `deploy-to-gcp.sh`