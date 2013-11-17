#!/bin/bash

# Run this script in the top nanopb directory to create a binary package
# for Windows users. This script is designed to run under MingW/MSYS bash

set -e
set -x

VERSION=`git describe --always`
DEST=dist/$VERSION

rm -rf $DEST
mkdir -p $DEST

# Export the files from newest commit
git archive HEAD | tar x -C $DEST

# Rebuild the Python .proto files
make -BC $DEST/generator/proto

# Make the nanopb generator available as a protoc plugin
cp $DEST/generator/nanopb_generator.py $DEST/generator/protoc-gen-nanopb.py

# Package the Python libraries
( cd $DEST/generator; bbfreeze nanopb_generator.py protoc-gen-nanopb.py )
mv $DEST/generator/dist $DEST/generator-bin

# Remove temp file
rm $DEST/generator/protoc-gen-nanopb.py

# Package the protoc compiler
cp `which protoc`.exe $DEST/generator-bin/

