#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color

offset=4
IFS=' '
name=()
for i in 0 1 2 3
do
ln=`expr $offset - $i`
line=$(tail -n $ln /etc/hosts|head -1)
read -ra arr <<< "$line"
name[$i]=${arr[1]}
done


# Only in node1
cp ~/OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar /usr/lib/jvm/

for i in 1 2 3
do
scp /usr/lib/jvm/OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar root@${name[$i]}:/usr/lib/jvm/
done


tar -xvf /usr/lib/jvm/OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar -C /usr/lib/jvm

echo 'export JAVA_HOME=/usr/lib/jvm/jdk8u292-b10'>>/etc/profile

source /etc/profile

mkdir -p /home/modules/
cp ~/hadoop-2.7.7.tar /home/modules/
tar -xvf /home/modules/hadoop-2.7.7.tar -C /home/modules/

chmod -R 755 /home/modules/hadoop-2.7.7

echo '# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.
export JAVA_HOME=/usr/lib/jvm/jdk8u292-b10

# The jsvc implementation to use. Jsvc is required to run secure datanodes
# that bind to privileged ports to provide authentication of data transfer
# protocol.  Jsvc is not required if SASL is configured for authentication of
# data transfer protocol using non-privileged ports.
#export JSVC_HOME=${JSVC_HOME}

export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}

# Extra Java CLASSPATH elements.  Automatically insert capacity-scheduler.
for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar; do
  if [ "$HADOOP_CLASSPATH" ]; then
    export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
  else
    export HADOOP_CLASSPATH=$f
  fi
done

# The maximum amount of heap to use, in MB. Default is 1000.
#export HADOOP_HEAPSIZE=
#export HADOOP_NAMENODE_INIT_HEAPSIZE=""

# Extra Java runtime options.  Empty by default.
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true"

# Command specific options appended to HADOOP_OPTS when specified
export HADOOP_NAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_NAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,RFAS $HADOOP_DATANODE_OPTS"

export HADOOP_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_SECONDARYNAMENODE_OPTS"

export HADOOP_NFS3_OPTS="$HADOOP_NFS3_OPTS"
export HADOOP_PORTMAP_OPTS="-Xmx512m $HADOOP_PORTMAP_OPTS"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="-Xmx512m $HADOOP_CLIENT_OPTS"
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

# On secure datanodes, user to run the datanode as after dropping privileges.
# This **MUST** be uncommented to enable secure HDFS if using privileged ports
# to provide authentication of data transfer protocol.  This **MUST NOT** be
# defined if SASL is configured for authentication of data transfer protocol
# using non-privileged ports.
export HADOOP_SECURE_DN_USER=${HADOOP_SECURE_DN_USER}

# Where log files are stored.  $HADOOP_HOME/logs by default.
#export HADOOP_LOG_DIR=${HADOOP_LOG_DIR}/$USER

# Where log files are stored in the secure data environment.
export HADOOP_SECURE_DN_LOG_DIR=${HADOOP_LOG_DIR}/${HADOOP_HDFS_USER}

###
# HDFS Mover specific parameters
###
# Specify the JVM options to be used when starting the HDFS Mover.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HADOOP_MOVER_OPTS=""

###
# Advanced Users Only!
###

# The directory where pid files are stored. /tmp by default.
# NOTE: this should be set to a directory that can only be written to by 
#       the user that will run the hadoop daemons.  Otherwise there is the
#       potential for a symlink attack.
export HADOOP_PID_DIR=${HADOOP_PID_DIR}
export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}

# A string representing this instance of hadoop. $USER by default.
export HADOOP_IDENT_STRING=$USER
' > /home/modules/hadoop-2.7.7/etc/hadoop/hadoop-env.sh

echo -e "${RED}Enter your access key:${NC}"
read ackey
echo -e "${RED}Enter your secret key:${NC}"
read sckey
echo -e "${RED}Enter your endpoint:${NC}"
read ep

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<!--
  Licensed under the Apache License, Version 2.0 (the \"License\");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an \"AS IS\" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
    <property>
        <name>fs.obs.readahead.inputstream.enabled</name>
        <value>true</value>
    </property>
    <property>
        <name>fs.obs.buffer.max.range</name>
        <value>6291456</value>
    </property>
    <property>
        <name>fs.obs.buffer.part.size</name>
        <value>2097152</value>
    </property>
    <property>
        <name>fs.obs.threads.read.core</name>
        <value>500</value>
    </property>
    <property>
        <name>fs.obs.threads.read.max</name>
        <value>1000</value>
    </property>
    <property>
        <name>fs.obs.write.buffer.size</name>
        <value>8192</value>
    </property>
    <property>
        <name>fs.obs.read.buffer.size</name>
        <value>8192</value>
    </property>
    <property>
        <name>fs.obs.connection.maximum</name>
        <value>1000</value>
    </property>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://${name[0]}:8020</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/modules/hadoop-2.7.7/tmp</value>
    </property>
    <property>
        <name>fs.obs.access.key</name>
        <value>${ackey}</value>
    </property>
    <property>
        <name>fs.obs.secret.key</name>
        <value>${sckey}</value>
    </property>
    <property>
        <name>fs.obs.endpoint</name>
        <value>${ep}:5080</value>
    </property>
    <property>
        <name>fs.obs.buffer.dir</name>
        <value>/home/modules/data/buf</value>
    </property>
    <property>
        <name>fs.obs.impl</name>
        <value>org.apache.hadoop.fs.obs.OBSFileSystem</value>
    </property>
    <property>
        <name>fs.obs.connection.ssl.enabled</name>
        <value>false</value>
    </property>
    <property>
        <name>fs.obs.fast.upload</name>
        <value>true</value>
    </property>
    <property>
        <name>fs.obs.socket.send.buffer</name>
        <value>65536</value>
    </property>
    <property>
        <name>fs.obs.socket.recv.buffer</name>
        <value>65536</value>
    </property>
    <property>
        <name>fs.obs.max.total.tasks</name>
        <value>20</value>
    </property>
    <property>
        <name>fs.obs.threads.max</name>
        <value>20</value>
    </property>
</configuration>" > /home/modules/hadoop-2.7.7/etc/hadoop/core-site.xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<!--
  Licensed under the Apache License, Version 2.0 (the \"License\");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an \"AS IS\" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
 <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
    <property>
        <name>dfs.namenode.secondary.http-address</name>
        <value>${name[0]}:50090</value>
    </property>
    <property>
        <name>dfs.namenode.secondary.https-address</name>
        <value>${name[0]}:50091</value>
    </property>
</configuration>" > /home/modules/hadoop-2.7.7/etc/hadoop/hdfs-site.xml

echo "<?xml version=\"1.0\"?>
<!--
  Licensed under the Apache License, Version 2.0 (the \"License\");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an \"AS IS\" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->
<configuration>

<!-- Site specific YARN configuration properties -->
<property>
    <name>yarn.nodemanager.local-dirs</name>
    <value>/home/nm/localdir</value>
</property><property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>28672</value>
</property><property>
    <name>yarn.scheduler.minimum-allocation-mb</name>
    <value>3072</value>
</property><property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>28672</value>
</property><property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>38</value>
</property><property>
    <name>yarn.scheduler.maximum-allocation-vcores</name>
    <value>38</value>
</property><property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
</property><property>
    <name>yarn.resourcemanager.hostname</name>
    <value>${name[0]}</value>
</property><property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
</property><property>
    <name>yarn.log-aggregation.retain-seconds</name>
    <value>106800</value>
</property><property>
    <name>yarn.nodemanager.vmem-check-enabled</name>
    <value>false</value>
    <description>Whether virtual memory limits will be enforced for containers</description>
</property><property>
    <name>yarn.nodemanager.vmem-pmem-ratio</name>
    <value>4</value>
    <description>Ratio between virtual memory to physical memory when setting memory limits for
containers</description>
</property><property>
    <name>yarn.resourcemanager.scheduler.class</name>
    <value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value>
</property><property>
    <name>yarn.log.server.url</name>
    <value>http://${name[0]}:19888/jobhistory/logs</value>
</property>
</configuration>
" > /home/modules/hadoop-2.7.7/etc/hadoop/yarn-site.xml

mv /home/modules/hadoop-2.7.7/etc/hadoop/mapred-site.xml.template /home/modules/hadoop-2.7.7/etc/hadoop/mapred-site.xml

echo "<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<!--
  Licensed under the Apache License, Version 2.0 (the \"License\");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an \"AS IS\" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
<property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
</property><property>
    <name>mapreduce.jobhistory.address</name>
    <value>${name[0]}:10020</value>
</property><property>
    <name>mapreduce.jobhistory.webapp.address</name>
    <value>${name[0]}:19888</value>
</property><property>
    <name>mapred.task.timeout</name>
    <value>1800000</value>
</property>
</configuration>
" >/home/modules/hadoop-2.7.7/etc/hadoop/mapred-site.xml

echo "
${name[1]}
${name[2]}
${name[3]}
" >/home/modules/hadoop-2.7.7/etc/hadoop/slaves

mv /home/modules/hadoop-2.7.7.tar /home/modules/hadoop-2.7.7.tar.old

cd /home/modules/
tar -cvf hadoop-2.7.7.tar hadoop-2.7.7

for i in 1 2 3
do
scp /home/modules/hadoop-2.7.7.tar root@${name[$i]}:~
done


echo "export HADOOP_HOME=/home/modules/hadoop-2.7.7
export PATH=\$JAVA_HOME/bin:\$PATH
export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH
export HADOOP_CLASSPATH=/home/modules/hadoop-2.7.7/share/hadoop/tools/lib/*:\$HADOOP_CLASSPATH
export HADOOP_PREFIX=/home/modules/hadoop-2.7.7" >> /etc/profile
 
source /etc/profile

hadoop namenode -format
