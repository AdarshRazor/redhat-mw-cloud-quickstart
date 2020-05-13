#!/bin/sh

/bin/date +%H:%M:%S >> install.progress.txt
echo "ooooo      RED HAT JBoss EAP 7.2 RPM INSTALL      ooooo" >> install.progress.txt

export EAP_HOME="/opt/rh/eap7/root/usr/share/wildfly"

JBOSS_EAP_USER=$1
JBOSS_EAP_PASSWORD=$2
RHSM_USER=$3
RHSM_PASSWORD=$4
RHEL_OS_LICENSE_TYPE=$5
RHSM_POOL=$6
IP_ADDR=$(hostname -I)

echo "JBoss EAP admin user"+${JBOSS_EAP_USER} >> install.progress.txt
echo "Initial JBoss EAP 7.2 setup" >> install.progress.txt
subscription-manager register --username $RHSM_USER --password $RHSM_PASSWORD  >> install.out.txt 2>&1
echo $? >> install.progress.txt
if [ $? != 0 ] ; then exit $? ; fi
subscription-manager attach --pool=${RHSM_POOL} >> install.out.txt 2>&1
if [ $? != 0 ] ; then exit $? ; fi
if [ $RHEL_OS_LICENSE_TYPE == "BYOS" ] 
then 
    echo "Attaching Pool ID for RHEL OS" >> install.progress.txt
    subscription-manager attach --pool=$7 >> install.out.txt 2>&1
    if [ $? != 0 ] ; then exit $? ; fi
fi
echo "Subscribing the system to get access to JBoss EAP 7.2 repos" >> install.progress.txt

# Install JBoss EAP 7.2
subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms >> install.out.txt 2>&1
if [ $? != 0 ] ; then exit $? ; fi
yum-config-manager --disable rhel-7-server-htb-rpms

echo "Installing JBoss EAP 7.2 repos" >> install.progress.txt
yum groupinstall -y jboss-eap7 >> install.out.txt 2>&1
if [ $? != 0 ] ; then exit $? ; fi

echo "Start JBoss-EAP service" >> install.progress.txt
$EAP_HOME/bin/standalone.sh -c standalone-full.xml -b $IP_ADDR -bmanagement $IP_ADDR & >> install.out.txt 2>&1
if [ $? != 0 ] ; then exit $? ; fi

echo "Installing GIT" >> install.progress.txt
yum install -y git >> install.out.txt 2>&1

echo "Getting the sample JBoss-EAP on Azure app to install" >> install.progress.txt
git clone https://github.com/Suraj2093/dukes.git >> install.out.txt 2>&1
if [ $? != 0 ] ; then exit $? ; fi
mv ./dukes/target/JBoss-EAP_on_Azure.war $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war >> install.out.txt 2>&1
cat > $EAP_HOME/standalone/deployments/JBoss-EAP_on_Azure.war.dodeploy >> install.out.txt 2>&1

echo "Configuring JBoss EAP management user" >> install.progress.txt
$EAP_HOME/bin/add-user.sh -u $JBOSS_EAP_USER -p $JBOSS_EAP_PASSWORD -g 'guest,mgmtgroup' >> install.out.txt 2>&1
if [ $? != 0 ] ; then exit $? ; fi

# Open Red Hat software firewall for port 8080 and 9990:
firewall-cmd --zone=public --add-port=8080/tcp --permanent  >> install.out.txt 2>&1
firewall-cmd --zone=public --add-port=9990/tcp --permanent  >> install.out.txt 2>&1
firewall-cmd --reload  >> install.out.txt 2>&1
    
echo "Done." >> install.progress.txt
/bin/date +%H:%M:%S >> install.progress.txt

# Open Red Hat software firewall for port 22:
firewall-cmd --zone=public --add-port=22/tcp --permanent >> install.out.txt 2>&1
firewall-cmd --reload >> install.out.txt 2>&1

# Seeing a race condition timing error so sleep to delay
sleep 20

echo "ALL DONE!" >> install.progress.txt
/bin/date +%H:%M:%S >> install.progress.txt
