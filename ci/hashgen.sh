#!/bin/sh

for f in *.zip; do shasum -a 256 $f > $f.sha256; done