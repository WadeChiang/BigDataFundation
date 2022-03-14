#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}Close firewall.$NC"

systemctl stop firewalld
systemctl disable firewalld

echo -e "${RED}Enter Node0-3's info. e.g.:
ip name $NC"
for i in 0 1 2 3
do
    read ip[$i] name[$i]
done

echo "::1	localhost	localhost.localdomain	localhost6	localhost6.localdomain6
#127.0.0.1	localhost	localhost.localdomain	localhost4	localhost4.localdomain4
#127.0.0.1	localhost	localhost" > /etc/hosts

for i in 0 1 2 3
do
    echo "${ip[$i]} ${name[$i]}" >> /etc/hosts
done

if [ ! -f ~/.ssh/id_rsa ];then
 ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
else
 echo -e "${RED}id_rsa has created ...${NC}"
fi

echo -e "${RED}Pub rsa key:${NC}"

cat ~/.ssh/id_rsa.pub

echo -e "${RED}Enter 4 node's pubkey:${NC}"
for i in 0 1 2 3
do
    read pubkey[$i]
    echo "${pubkey[$i]}" >> ~/.ssh/authorized_keys
done