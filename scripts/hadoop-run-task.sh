#!/bin/bash

echo "Running Hadoop job with:"
echo "JAR: $JAR_FILEPATH"
echo "Class: $CLASS_TO_RUN"
echo "Params: $PARAMS"

$HADOOP_HOME/bin/hadoop jar $JAR_FILEPATH \
  -D yarn.app.mapreduce.am.resource.mb=1024 \
  -D mapreduce.map.memory.mb=1024 \
  -D mapreduce.reduce.memory.mb=1024 \
  $PARAMS

