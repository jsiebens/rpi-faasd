#!/bin/sh

for f in *.tgz; do shasum -a 256 $f > $f.sha256; done