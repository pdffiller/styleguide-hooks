#!/bin/bash

for file in *.bats; do
    echo "Run tests for $file" | cut -d'.' -f1
    bats $file
    echo ''
done
