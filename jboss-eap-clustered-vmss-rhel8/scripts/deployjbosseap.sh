#!/bin/sh

# $1 - VM Host User Name

echo "Red Hat JBoss EAP 7.2 Cluster Intallation Start " >> /home/$1/install.log
/bin/date +%H:%M:%S  >> /home/$1/install.log

export EAP_HOME="/opt/rh/eap7/root/usr/share"
JBOSS_EAP_USER=$2
JBOSS_EAP_PASSWORD=$3
OFFER=$4
RHSM_USER=$5	
RHSM_PASSWORD=$6
RHSM_POOL=$7
IP_ADDR=$(hostname -I)
STORAGE_ACCOUNT_NAME=${8}	
CONTAINER_NAME=$9
STORAGE_ACCESS_KEY=$(echo "${10}" | openssl enc -d -base64)

echo "JBoss EAP admin user"+${JBOSS_EAP_USER} >> /home/$1/install.log
echo "Private IP Address of VM"+${IP_ADDR} >> /home/$1/install.log
echo "Storage Account Name"+${STORAGE_ACCOUNT_NAME} >> /home/$1/install.log
echo "Storage Container Name"+${CONTAINER_NAME} >> /home/$1/install.log
echo "Storage Account Access Key"+${STORAGE_ACCESS_KEY} >> /home/$1/install.log
echo "RHSM_USER: " ${RHSM_USER} >> /home/$1/install.log	
echo "RHSM_POOL: " ${RHSM_POOL} >> /home/$1/install.log

echo "Configure firewall for ports 8080, 8180, 9990, 10090..." >> /home/$1/install.log 

sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9990/tcp --permanent
sudo firewall-cmd --zone=public --add-port=45700/tcp --permanent
sudo firewall-cmd --zone=public --add-port=7600/tcp --permanent
sudo firewall-cmd --zone=public --add-port=55200/tcp --permanent
sudo firewall-cmd --zone=public --add-port=45688/tcp --permanent
sudo firewall-cmd --reload
sudo iptables-save

echo "Initial JBoss EAP 7.2 setup" >> /home/$1/install.log
subscription-manager register --username $RHSM_USER --password $RHSM_PASSWORD
subscription-manager attach --pool=${RHSM_POOL}
if [ $OFFER == "BYOS" ]
then
    echo "Attaching Pool ID for RHEL OS" >> /home/$1/install.log
    subscription-manager attach --pool=${11}
fi
echo "Subscribing the system to get access to JBoss EAP 7.2 repos" >> /home/$1/install.log

echo "Install openjdk, wget, git, unzip, vim"  >> /home/$1/install.log 
sudo yum install java-1.8.0-openjdk wget unzip vim git -y

# Install JBoss EAP 7.2 	
subscription-manager repos --enable=jb-eap-7.2-for-rhel-8-x86_64-rpms >> /home/$1/install.log

echo "Installing JBoss EAP 7.2 repos" >> /home/$1/install.log
yum groupinstall -y jboss-eap7 >> /home/$1/install.log

echo "Copy the standalone-azure-ha.xml from EAP_HOME/doc/wildfly/examples/configs folder to EAP_HOME/wildfly/standalone/configuration folder" >> /home/$1/install.log
cp $EAP_HOME/doc/wildfly/examples/configs/standalone-azure-ha.xml $EAP_HOME/wildfly/standalone/configuration/

echo "change the jgroups stack from UDP to TCP " >> /home/$1/install.log
sed -i 's/stack="udp"/stack="tcp"/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml

echo "Update interfaces section update jboss.bind.address.management, jboss.bind.address and jboss.bind.address.private from 127.0.0.1 to 0.0.0.0" >> /home/$1/install.log
sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml
sed -i 's/jboss.bind.address:127.0.0.1/jboss.bind.address:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml
sed -i 's/jboss.bind.address.private:127.0.0.1/jboss.bind.address.private:0.0.0.0/g'  $EAP_HOME/wildfly/standalone/configuration/standalone-azure-ha.xml

echo "Start JBoss server" >> /home/$1/install.log

$EAP_HOME/wildfly/bin/standalone.sh -bprivate $IP_ADDR -b $IP_ADDR -bmanagement $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true &

echo "export EAP_HOME="/opt/rh/eap7/root/usr/share"" >>/bin/jbossservice.sh
echo "$EAP_HOME/wildfly/bin/standalone.sh -bprivate $IP_ADDR -b $IP_ADDR -bmanagement $IP_ADDR --server-config=standalone-azure-ha.xml -Djboss.jgroups.azure_ping.storage_account_name=$STORAGE_ACCOUNT_NAME -Djboss.jgroups.azure_ping.storage_access_key=$STORAGE_ACCESS_KEY -Djboss.jgroups.azure_ping.container=$CONTAINER_NAME -Djava.net.preferIPv4Stack=true &" > /bin/jbossservice.sh
chmod +x /bin/jbossservice.sh

yum install cronie cronie-anacron
service crond start
chkconfig crond on
echo "@reboot sleep 90 && /bin/jbossservice.sh" >>  /var/spool/cron/root
chmod 600 /var/spool/cron/root

echo "Deploy an application " >> /home/$1/install.log
git clone https://github.com/Suraj2093/eap-session-replication.git
cp eap-session-replication/target/eap-session-replication.war $EAP_HOME/wildfly/standalone/deployments/
touch $EAP_HOME/wildfly/standalone/deployments/eap-session-replication.war.dodeploy

echo "Configuring JBoss EAP management user..." >> /home/$1/install.log 
$EAP_HOME/wildfly/bin/add-user.sh  -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup'

# Seeing a race condition timing error so sleep to deplay
sleep 20

echo "Red Hat JBoss EAP 7.2 Cluster Intallation End " >> /home/$1/install.log
/bin/date +%H:%M:%S  >> /home/$1/install.log