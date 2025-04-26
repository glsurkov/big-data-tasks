#!/bin/sh
set -e
set -x

echo ">>> Cleaning HDFS /input and /output"
hdfs dfs -rm -r -f /input /output || true

echo ">>> Creating /input directory"
hdfs dfs -mkdir -p /input/

echo ">>> Copying input files to HDFS"
hdfs dfs -copyFromLocal -f /opt/hadoop/input/*.txt /input/

echo ">>> Running MapReduce job"
/hadoop-run-task.sh

echo ">>> HDFS Output"
hdfs dfs -test -e /output

echo ">>> Copying output to /output-local"
hdfs dfs -copyToLocal /output/* /output-local/

echo "Done"
