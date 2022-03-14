# 大数据技术基础

labs and notes of Big Data Foundation 2022 in BUPT SCS.

北京邮电大学计算机学院大数据技术基础2022的实验代码与笔记。

## Lab 1&2：配置 Hadoop 集群

### Lab1 

不包含任何代码。

### Lab2 

本实验需要在四台服务器上同时配置节点，造成了大量的重复操作，因此实验时我开始考虑用 shell 脚本来实现重复操作。

脚本分为三部分：

- `authorize.sh`: 配置 ssh rsa key 以及 hosts。在 master(node 0) 以及 slaves(node 1-3) 上运行。
- `main.sh`: Java, Hadoop 环境以及 namenode 配置。仅在 master 上运行。
- `slaves.sh`：接收、配置来自 master的 Java 以及 Hadoop 环境。仅在 slaves 上运行。
  
详细操作说明位于 `/lab2/readme.md`

