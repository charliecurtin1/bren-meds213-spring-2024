#!/bin/bash

# assign arguments to variables
label="$1"
num_reps="$2"
query="$3"
db_file="$4"
csv_file="$5"

# record start time
start=$(date +%s)

# for loop that executes a query a specified number of times
for i in $(seq "$num_reps"); do
    # execute query and redirect output so that it isn't output
    duckdb "$db_file" "$query" >/dev/null
done

# record end time
end=$(date +%s)

# compute elapsed time
elapsed=$(echo "scale=7; ($end - $start)/$num_reps" | bc)

# output the elapsed time to the timings csv file
echo "$label,$elapsed" >> "$csv_file"