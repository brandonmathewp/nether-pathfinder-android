#!/usr/bin/env bash
set -e

VERSION="${1:-1.4.1}"
JAR="nether-pathfinder-${VERSION}-android.jar"

if [ ! -f "$JAR" ]; then
    echo "Run package.sh first to create $JAR"
    exit 1
fi

MAVEN_PATH="dev/babbaj/nether-pathfinder/${VERSION}"
REPO_BRANCH="maven-repo"
REMOTE="$(git remote get-url origin)"

echo "Publishing to Maven repo at $REMOTE (branch: $REPO_BRANCH)..."

# Work in temp directory
WORKTREE="/tmp/maven-publish-$$"
rm -rf "$WORKTREE"

# Clone or init the maven repo branch
if git ls-remote --heads origin "$REPO_BRANCH" | grep -q "$REPO_BRANCH"; then
    git clone --branch "$REPO_BRANCH" --depth 1 "$REMOTE" "$WORKTREE"
else
    mkdir -p "$WORKTREE"
    cd "$WORKTREE"
    git init
    git checkout -b "$REPO_BRANCH"
    cd -
fi

cd "$WORKTREE"
mkdir -p "$MAVEN_PATH"

# Copy JAR
cp "/tmp/nether-pathfinder-android/$JAR" "$MAVEN_PATH/nether-pathfinder-${VERSION}.jar"

# POM
cat > "$MAVEN_PATH/nether-pathfinder-${VERSION}.pom" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>dev.babbaj</groupId>
  <artifactId>nether-pathfinder</artifactId>
  <version>${VERSION}</version>
</project>
EOF

# Commit and push
git add -A
if ! git diff --cached --quiet; then
    git -c user.name=brandonmathewp -c user.email=brandonmathewp@users.noreply.github.com commit -m "Release ${VERSION}"
    git push "$REMOTE" "$REPO_BRANCH" 2>&1 || {
        # Remote might not be set up yet for fresh init
        git remote add origin "$REMOTE" 2>/dev/null || true
        git push origin "$REPO_BRANCH"
    }
    echo "Published: https://brandonmathewp.github.io/nether-pathfinder-android/${MAVEN_PATH}/nether-pathfinder-${VERSION}.jar"
else
    echo "Already up to date"
fi

rm -rf "$WORKTREE"
