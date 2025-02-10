#!/bin/bash
# ------------------------------------------------
# Script   : skopeo-download
# Descrição:
# Versão   : 1.0.0
# Autor    : Vinicius https://github.com/souovan
# Data     : 10/02/2025
# ------------------------------------------------

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Copyright (C) 2025 - Vinicius Antonio do Nascimento - <https://github.com/souovan>
# License: MIT <https://choosealicense.com/licenses/mit/>


# Variables
REGISTRY=""  # Replace with your registry URL (e.g., docker.io)
REGISTRY_USER="" # Replace with your registry username (if authentication is required)
REGISTRY_PASS="" # Replace with your registry password (if authentication is required)

# Array of repositories to download
REPOSITORIES=(
    "repo1"
    "repo2"
    "repoN..."
)

# Authenticate with the registry (if required)
if [[ -n "$REGISTRY_USER" && -n "$REGISTRY_PASS" ]]; then
    echo "Authenticating with the registry..."
    skopeo login -u "$REGISTRY_USER" -p "$REGISTRY_PASS" "$REGISTRY"
fi

# Filter repositories to download only the ones in the array
for REPO in "${REPOSITORIES[@]}"; do
    # Trim leading/trailing whitespace from the repository name
    REPO=$(echo "$REPO" | xargs)

    echo "Processing repository: $REPO"
    TAGS=$(skopeo list-tags "docker://$REGISTRY/$REPO" | jq -r '.Tags[]')

    if [[ -z "$TAGS" ]]; then
        echo "No tags found for repository: $REPO"
        continue
    fi

    # Download each tag
    for TAG in $TAGS; do
        echo "Downloading image: $REPO:$TAG"
        podman pull "$REGISTRY/$REPO:$TAG"
    done
done

echo "Download completed."

