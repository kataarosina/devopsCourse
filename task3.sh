#!/bin/bash

read -p "Enter the Git repository URL: " REPO_URL

git clone "$REPO_URL"
if [ $? -ne 0 ]; then
    echo "Failed to clone the repository."
    exit 1
fi

REPO_DIR=$(basename "$REPO_URL" .git)

cd "$REPO_DIR" || exit 1

LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)

if [ -z "$LATEST_TAG" ]; then
    NEW_TAG="1.0.0"
    git tag -a "$NEW_TAG" -m "Initial tag $NEW_TAG"
    git push origin "$NEW_TAG"
    echo "Created initial tag: $NEW_TAG"
else
    TAG_COMMIT=$(git rev-list -n 1 "$LATEST_TAG")
    HEAD_COMMIT=$(git rev-parse HEAD)

    if [ "$TAG_COMMIT" = "$HEAD_COMMIT" ]; then
        echo "No changes."
    else
        IFS='.' read -r MAJOR MINOR PATCH <<< "$LATEST_TAG"
        PATCH=$((PATCH + 1))
        NEW_TAG="${MAJOR}.${MINOR}.${PATCH}"
        git tag -a "$NEW_TAG" -m "Bump version to $NEW_TAG"
        git push origin "$NEW_TAG"
        echo "Created new tag: $NEW_TAG"
    fi
fi

cd ..
rm -rf "$REPO_DIR"
