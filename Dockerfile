# Base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

# Set Hadoop environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    HADOOP_HOME=/usr/local/hadoop \
    PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin \
    HDFS_NAMENODE_USER="root" \
    HDFS_DATANODE_USER="root" \
    HDFS_SECONDARYNAMENODE_USER="root"

# Copy Hadoop Installer and othter components
COPY ./script.sh /app/

# Install Hadoop & other components
RUN apt update && \
    apt install -y openjdk-11-jdk &&  apt install -y wget && \ 
    wget -P /app https://archive.apache.org/dist/hadoop/common/hadoop-3.3.3/hadoop-3.3.3.tar.gz && \
    tar -xzf /app/hadoop-3.3.3.tar.gz -C /app && \
    rm /app/hadoop-3.3.3.tar.gz && \
    mv /app/hadoop-3.3.3 $HADOOP_HOME && \
    chmod +x /app/script.sh && \
    apt-get clean

# Copy the script file
#ADD ../script.sh /app/

# Modify the script to be executable
#RUN chmod +x /app/script.sh

# Expose Hadoop ports
EXPOSE 9864 9868 9870

# Start the Hadoop application
ENTRYPOINT ["/app/script.sh"]
