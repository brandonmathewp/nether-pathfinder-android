#!/usr/bin/env bash
set -e

VERSION="${1:-1.4.1}"
JAR="nether-pathfinder-${VERSION}-android.jar"

if [ ! -f "$JAR" ]; then
    echo "Run package.sh first to create $JAR"
    exit 1
fi

MAVEN_DIR="$HOME/.m2/repository/dev/babbaj/nether-pathfinder/${VERSION}"
mkdir -p "$MAVEN_DIR"
cp "$JAR" "$MAVEN_DIR/nether-pathfinder-${VERSION}.jar"

cat > "$MAVEN_DIR/nether-pathfinder-${VERSION}.pom" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <modelVersion>4.0.0</modelVersion>
  <groupId>dev.babbaj</groupId>
  <artifactId>nether-pathfinder</artifactId>
  <version>${VERSION}</version>
</project>
EOF

echo "Published to $MAVEN_DIR"
