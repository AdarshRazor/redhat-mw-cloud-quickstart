#!/bin/sh

echo "WILDFLY 18.0.1.Final Standalone Intallation Start..." >> /home/$1/install.log
/bin/date +%H:%M:%S  >> /home/$1/install.log

WILDFLY_USER=$2
WILDFLY_PASSWORD=$3
IP_ADDR=$(hostname -I)
Public_IP=$(curl ifconfig.me)

echo "WILDFLY_USER: " ${WILDFLY_USER} >> /home/$1/install.log
echo "Private IP Address: " ${IP_ADDR} >> /home/$1/install.log
echo "Public IP Address: " ${Public_IP} >> /home/$1/install.log

echo "WILDFLY Downloading..." >> /home/$1/install.log
cd /home/$1
yum install -y git unzip java
yum -y install wget
WILDFLY_RELEASE="18.0.1"
wget https://download.jboss.org/wildfly/$WILDFLY_RELEASE.Final/wildfly-$WILDFLY_RELEASE.Final.tar.gz
tar xvf wildfly-$WILDFLY_RELEASE.Final.tar.gz

echo "Sample app deploy..." >> /home/$1/install.log 
git clone https://github.com/Suraj2093/dukes.git
/bin/cp -rf /home/$1/dukes/target/JBoss-EAP_on_Azure.war /home/$1/wildfly-$WILDFLY_RELEASE.Final/standalone/deployments/

echo "Configuring WILDFLY managment user..." >> /home/$1/install.log 
/home/$1/wildfly-$WILDFLY_RELEASE.Final/bin/add-user.sh -u $WILDFLY_USER -p $WILDFLY_PASSWORD -g 'guest,mgmtgroup' 

echo "Start WILDFLY 18.0.1.Final instance..." >> /home/$1/install.log 
/home/$1/wildfly-$WILDFLY_RELEASE.Final/bin/standalone.sh -b $Public_IP -bmanagement $Public_IP > /dev/null 2>&1 &

echo "Configure firewall for ports 8080, 9990..." >> /home/$1/install.log 
firewall-cmd --zone=public --add-port=8080/tcp --permanent 
firewall-cmd --zone=public --add-port=9990/tcp --permanent 
firewall-cmd --reload

echo "Open WILDFLY software firewall for port 22..." >> /home/$1/install.log
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload

echo "WILDFLY 18.0.1.Final Standalone Intallation End..." >> /home/$1/install.log
/bin/date +%H:%M:%S >> /home/$1/install.log
