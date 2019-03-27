#!/bin/bash

function gcp_refresh() {
  dest=${GCP_DIR:-"$HOME/dum-e/gcp/$proj.instances"}
  echo "cloning to $dest..."
  projects=$(gcloud projects list | awk -F' ' 'NR > 1 { print $1}')
  mkdir -p gcp
  for proj in ${projects}
  do
    echo "refreshing $proj..."
    gcloud compute instances list --project $proj > $dest &
  done

  wait
}
