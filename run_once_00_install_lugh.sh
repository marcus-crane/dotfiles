#!/bin/bash

VERSION=v0.0.3
SYSTEM=$(uname | tr '[:upper:]' '[:lower:]')

cd /tmp && \
wget -q https://github.com/marcus-crane/lugh/releases/download/$VERSION/lugh-"$SYSTEM"-$VERSION.tar.gz -O lugh.tar.gz && \
tar -xf lugh.tar.gz && \
mv bin/lugh /usr/local/bin && \
rm lugh.tar.gz && \
rm -rf bin && \
echo "Lugh $VERSION for $SYSTEM installed"

