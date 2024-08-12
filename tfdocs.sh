#!/bin/bash

# Generate README.md for the root level if needed
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.17.0 markdown /terraform-docs/modules/cluster > README.md

# Loop through the directories at the root level and generate README.md for each
for dir in */; do
  # Strip trailing slash for directory name
  dir=${dir%/}

  # Ensure it's a directory and not 'docs' (since it already has a README.md)
  if [ -d "$dir" ] && [ "$dir" != "docs" ]; then
    echo "Processing $dir"
    docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.17.0 markdown /terraform-docs/$dir > $dir/README.md
  fi
done
