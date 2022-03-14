# 操作说明

## 准备工作

使用 scp 上传 hadoop-2.9.9 至服务器前将文件夹打包为 tar 格式（`hadoop-2.9.9.tar`）后再传输。

保证 
```
authorize.sh
main.sh
OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar
hadoop-2.9.9.tar
``` 
位于 master 服务器 `/root` 目录下。

保证 `authorize.sh` 与 `slaves.sh` 位于 slaves 服务器 `/root` 目录下。

## 配置 ssh 与 host

**注意.** 配置 hosts 时请使用服务器的内网 IP。

在所有服务器上启动 `authorize.sh`

依次输入所有服务器的 IP 与 ID（正在操作的包括本机）。脚本将把 IP 与 ID 写入 `/etc/hosts`.

之后脚本将生成 ssh rsa key 并输出。将所有 pubkey 汇集起来后，输入给脚本。

建议提前准备好输入，需要时复制给脚本。例如：
```
192.168.0.x jzytest-114514-0001
192.168.0.x jzytest-114514-0002
192.168.0.x jzytest-114514-0003
192.168.0.x jzytest-114514-0004

#输出 pubkey 后的汇集：
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHcXM3PJt1yPPqad+ZOfcUsPjrelagQs8VmXfC5lKlEjBe0orzoZCYPXvBTxXI/+Vj9Gpyl1j1HOwIWao8n9jDnj+lgmyG3rKNgCuQA/f9Oljguny3d8n2Xcd1cMvOOAYvIm2nfB2z9tXAvyCrYUkYi0Tlvt0MFUt68FshEKBbA2kWDyAQeN/xsqNuU1tA4NMWGpa2K4+1WdxveLfszpVrTnlsJm1R9bVVd8+iAg9dxxmAgMVTR2OgBuULQ9lQnu1bZAjIfkzuIK8i8dS/vt5FeY3oCNfs65nZVCXY1K4QDywRPvm98XTDQZ4TTAGUAlVeh8GFbPLwRFxnJVEPNGeT root@jzytest-114514-0001
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaY9ZaKI9aHwzmjM9rgbYaU0hOPPZ0wacw23vjDkV6TgjFyqUxGN3deouTGcISf8a9raLUx1wwi2olFw/btaXlxORGkHYQq8vSNzfWQ21eGjKIoo9brvOEMPkhQ8yi/JgtcLjaYsGaAPW6farEyhsCkcUsTPz1zdXtIfpJlTVBk1TnnoB/iixTLOhxx9bFiYX3oU0bQBF1oP3BvKGUDcYCVWEzF1QuZUWhES9pc51xqfsvf5KzlQRPEJMvsE/m6nAyrHMapkfjNRSA9mXNG8Al2vYzmo9HSnkGcsnPk9BsMtZT2GN+h/QX4fDHhFKhvcMLkerKpKz//VuPY/RAAHrZ root@jzytest-114514-0002
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yLPb3AZx5xlsT94n4+eZhb/lWt1WC/tFd3XzXUIZjNvss1S9Dtt2eHvNWANlrZ/FxZ9pwS9RNOvqgyBJD386ArvKoRbpKHCPzoDOtG028lM/Bk6BUGwfmbxIOo5nkyOTS/K0EmG4QMQ1NOODUb4NNSOuYYvdufUZJdesCvLm+F8eYIDrF3OJ4nQtbeYBunfK9G0qG0IHmQ8N4pB0d1ZW+uG2Al1003QgSb6h20Vu+DypXdCmYqRmI6yPRLTUitVAttPIv3pZSerqdZAkgXdVhqFnv4VAfmaTg9UyDd5BGkv9sHZrHGy9MxmwhW8mLATER4jGJpcw28RIN26WkNZf root@jzytest-114514-0003
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIEC4KRZd4uWbBy/85qGk9j64eek1hyjrGFRg5W2AiwLpukzJninPisI2zSeqqNB58u+YcCZGirHSUc06/6gfjob9WbYGYkbyguIekqnNKuK3q81bNK4nnEmJPwFU08yODs8ggoE4a0yRU4u/9/D5vIpCOapCM+4XQbe6M4MCpCisMyCJ1YcqLaoYK/ffXXCE0xI1FSB1C/Q1teAi8btOQ1LDDCBTt9Mpmf/vtz9WOM0ee3Jq4hY3pKqnP0SM6NC+HofmupfCiHAAFbiCil2q3Dr4G2qdD9Kwt3pe6SACXoukZNhg9VURFH3vKFid8IaLvEBMXOGUtfzzm9IQfeODb root@jzytest-114514-0004
```

## 配置 JDK 与 Hadoop

准备好实验一中获得的 AccessKey, SecretKey 与 Endpoint。

先在 `master` 上运行 `main.sh`。根据要求输入准备好的 Keys。过程中可能会出现 `add xx to the list of known hosts(yes\no)`，输入 `yes` 即可。脚本成功执行完成的情况下，最后一条输出应该为
```
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at jzytest-114514-0001/192.168.0.x
************************************************************/
```

`main.sh` 运行完成后在各 slaves 上运行 `slaves.sh`。

以上均运行完成后输入 `start-all.sh` 启动 hadoop 集群。