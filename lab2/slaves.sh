#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color


tar -xvf /usr/lib/jvm/OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar -C /usr/lib/jvm

echo 'export JAVA_HOME=/usr/lib/jvm/jdk8u292-b10'>>/etc/profile

mkdir -p /home/modules/
cp ~/hadoop-2.7.7.tar /home/modules/
tar -xvf /home/modules/hadoop-2.7.7.tar -C /home/modules/

echo "export HADOOP_HOME=/home/modules/hadoop-2.7.7
export PATH=\$JAVA_HOME/bin:\$PATH
export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH
export HADOOP_CLASSPATH=/home/modules/hadoop-2.7.7/share/hadoop/tools/lib/*:\$HADOOP_CLASSPATH
export HADOOP_PREFIX=/home/modules/hadoop-2.7.7" >> /etc/profile
 
source /etc/profile

chmod -R 755 /home/modules/hadoop-2.7.7