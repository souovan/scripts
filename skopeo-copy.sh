#!/bin/bash
# ------------------------------------------------
# Script   : skopeo-copy
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

# Source and Destination Registry
SOURCE_REGISTRY=""
DEST_REGISTRY=""

# Credentials
SOURCE_CREDS="user:password"
DEST_CREDS="user:password"

# Repository List (Optional: You can dynamically fetch it from the registry)
REPOSITORIES=("repo1" "repo2" "repoN...")

# Iterate through repositories
for repo in "${REPOSITORIES[@]}"; do
    echo "Fetching tags for $repo..."

    # Get the list of tags from the source registry
    #TAGS=$(curl -s -u "$SOURCE_CREDS" "https://$SOURCE_REGISTRY/$repo/tags/list" | jq -r '.tags[]')
    # Fetch tags using Skopeo
    TAGS=$(skopeo list-tags --creds "$SOURCE_CREDS" "docker://$SOURCE_REGISTRY/$repo" | jq -r '.Tags[]')
    # Check if there are tags available
    if [ -z "$TAGS" ]; then
        echo "No tags found for $repo. Skipping..."
        continue
    fi

    # Copy each tag
    for tag in $TAGS; do
        echo "Copying $repo:$tag..."
        skopeo copy \
            --src-creds "$SOURCE_CREDS" \
            --dest-creds "$DEST_CREDS" \
            docker://$SOURCE_REGISTRY/$repo:$tag \
            docker://$DEST_REGISTRY/$repo:$tag
    done
done

echo "Image transfer complete!"

