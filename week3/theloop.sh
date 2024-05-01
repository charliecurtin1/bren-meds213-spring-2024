#!/bin/bash

for file in *.csv; do
    # print the number of lines in each file with the .csv extension
    echo "$file has $(wc -l < $file) lines"
done