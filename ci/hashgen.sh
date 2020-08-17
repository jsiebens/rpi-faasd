#!/bin/bash

for f in *.zip; do 
  [ -f "$f" ] || break
  shasum -a 256 $f > $f.sha256; 
done

for f in *.xz; do 
  [ -f "$f" ] || break
  shasum -a 256 $f > $f.sha256; 
done