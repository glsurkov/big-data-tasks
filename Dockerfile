FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

ARG TASK=task_1

COPY ./tasks/${TASK}/build/wordcount.jar /opt/hadoop/applications/wordcount.jar

COPY ./resources/*.txt /opt/hadoop/input/

ENV JAR_FILEPATH="/opt/hadoop/applications/wordcount.jar"
ENV CLASS_TO_RUN="HadoopDriver"
ENV PARAMS="/input /output"

ADD scripts/hadoop-run-task.sh /hadoop-run-task.sh
RUN chmod a+x /hadoop-run-task.sh

CMD ["/hadoop-run-task.sh"]
