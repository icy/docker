#!/bin/bash

echo The output of 'ls -ltr /empty/' command:
echo "======================================="
ls -ltr /empty/

echo "======================================="
echo

cat <<EOF
Expected results

  chmod.sh:  should have permission 755
  fail.sh:   should exist

Actual results

  chmod.sh:  has permission 644
  fail.sh:   file doesn't exist
EOF
