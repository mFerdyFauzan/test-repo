# Base image
FROM alpine:latest

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
COPY ./* /app/

# Install Hadoop & other components
RUN apt update && \
    apt -y install openjdk-11-jdk && \
    apt -y install openssh-server && \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    chmod +x /app/script.sh && \
    echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc && \
    echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc && \
    echo "export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin" >> ~/.bashrc && \
    tar -xzf /app/hadoop-3.3.3.tar.gz -C /app && \
    tar -xzf /app/GeoLite2-City_20221122.tar.gz -C /app && \
    mv /app/hadoop-3.3.3 $HADOOP_HOME && \
    mv hadoop-env.sh core-site.xml hdfs-site.xml $HADOOP_HOME/etc/hadoop/ && \
    rm -rf /app/hadoop-3.3.3.tar.gz /app/GeoLite2-City_20221122.tar.gz

# Copy the script file
#ADD ../script.sh /app/

# Modify the script to be executable
#RUN chmod +x /app/script.sh

# Expose Hadoop ports
EXPOSE 50010 50020 50070 50075 50090 8030 8031 8032 8033 8040 8042 8088 8080 9000 9864 9868 9870

# Start the Hadoop application
ENTRYPOINT ["/app/script.sh"]
