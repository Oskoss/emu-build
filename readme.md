# Mirroring Repo to Github for Autobuilds

The following steps are being run manually with the gcloud CLI. This could be wrapped with either a bash script or just Terraform directly.
1. Download, install and login to the `gcloud` CLI.
1. Create a Service Account
     ```
     gcloud iam service-accounts create gickup0 \
     --description="Service account utilized by gickup within cloud-run jobs" \
     --display-name="gickup0"
    ```
1. Add roles to Service Account for secret accessing and project editor
    ```
    gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:gickup0@PROJECT_ID.iam.gserviceaccount.com" \
    --role="Editor"
    ```
    ```
    gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="serviceAccount:gickup0@PROJECT_ID.iam.gserviceaccount.com" \
    --role="secretmanager.secretAccessor"
    ```
1. Obtain github access token and gogs (https://git.eq2emu.com/) access tokens. Add them to the [conf.yaml](https://github.com/oskoss/emu-build/blob/main/git-mirror/conf.yaml)
1. Add conf.yaml as a GCP Secret. `gcloud secrets create gickup-conf --data-file="/git-mirror/conf.yaml"`
1. Create Cloud Run Job `gcloud run jobs replace /git-mirror/cloud-run.yaml`
1. Create a Cron Schedule to run the Cloud Run Job every 12 hours
    ```
      gcloud scheduler jobs create http run-gickup \
      --location us-central1 \
      --schedule="0*/12***" \
      --uri="https://us-central1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/PROJECT-ID/jobs/mirror-devn00b:run" \
      --http-method POST \
      --oauth-service-account-email gickup0@PROJECT_ID.iam.gserviceaccount.com
    ```
