#!/bin/bash
projects=$(gcloud projects list | awk -F' ' 'NR > 1 { print $1}')
mkdir -p gcp
for proj in ${projects}
do
   echo "refreshing $proj..."
   gcloud compute instances list --project $proj > "$HOME/dum-e/gcp/$proj.instances" &
done

wait

