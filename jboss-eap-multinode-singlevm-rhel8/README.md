# JBoss EAP 7.2 on RHEL 8.0 (multi-node, single VM)
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-multinode-singlevm-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-multinode-singlevm-rhel8%2Fazuredeploy.json" target="_blank">
    <img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/>
</a>

`Tags: JBoss, Red Hat, EAP 7.2, Azure, Azure VM, JavaEE, RHEL 8.0`

<!-- TOC -->

1. [Solution Overview](#solution-overview)
2. [Template Solution Architecture](#template-solution-architecture)
3. [Licenses, Subscriptions and Costs](#licenses-subscriptions-and-costs)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Deployment Time](#deployment-time)
7. [Validation Steps](#validation-steps)
8. [Support](#support)

<!-- /TOC -->

## Solution Overview

JBoss EAP (Enterprise Application Platform) is an open source platform for highly transactional, web-scale Java applications. EAP combines the familiar and popular Jakarta EE specifications with the latest technologies, like Microprofile, to modernize your applications from traditional Java EE into the new world of DevOps, cloud, containers, and microservices. EAP includes everything needed to build, run, deploy, and manage enterprise Java applications in a variety of environments, including on-premise, virtual environments, and in private, public, and hybrid clouds.

Red Hat Subscription Management (RHSM) is a customer-driven, end-to-end solution that provides tools for subscription status and management and integrates with Red Hat's system management tools. To obtain an rhsm account for JBoss EAP, go to: www.redhat.com.

This Azure quickstart template creates all of the compute resources to run JBoss EAP 7.2 running on RHEL 8.0 VM.

## Template Solution Architecture
This template creates all the Azure compute resources to run JBoss EAP 7.2 on top of RHEL 8.0 VM. The following resources are created by this template:

- RHEL 8.0 VM 
- Public IP 
- Virtual Network 
- Network Security Group 
- JBoss EAP 7.2
- Sample application called eap-session-replication deployed on JBoss EAP 7.2
- Storage Account

Following is the Architecture:

![alt text](images/eap-rhel-arch.png)

To learn more about the JBoss Enterprise Application Platform, visit:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/


## Licenses, Subscriptions and Costs

If you select the RHEL OS License type as PAYG (Pay-As-You-Go), this template uses the On-Demand Red Hat Enterprise Linux 8.0 Pay-As-You-Go image from the Azure Gallery. When using the On-Demand image, there is an additional hourly RHEL subscription charge for using this image on top of the normal compute, network and storage costs. At the same time, the instance will be registered to your Red Hat subscription, so you will also be using one of your entitlements. Check [Red Hat Enterprise Linux pricing](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/red-hat/) for details on the VM price. This will lead to "double billing". To avoid this, you would need to build your own RHEL image, which is defined in this [Red Hat KB article](https://access.redhat.com/articles/uploading-rhel-image-to-azure). In addition you also need to have a Red Hat account to register to Red Hat Subscription Manager (RHSM) and install JBoss EAP. If you have a valid Red Hat subscription, register for Cloud Access, [request access](https://access.redhat.com/public-cloud) to the BYOS RHEL image in the Private Azure Marketplace and follow the below mentioned steps to avoid the double billing.

You can select the RHEL OS License type as BYOS (Bring-Your-Own-Subscription) for deploying the template to avoid double billing. Your RHSM account must have both Red Hat Enterprise Linux entitlement (for subscribing the RHEL OS for the VM) and EAP entitlement and you will have to enter both the pool IDs as mentioned in the template. To provision the RHEL-BYOS VM in your subscription, you will have to enable it in the Cloud Access from Red Hat portal and activate Red Hat Gold Images for your subscription. You can enable subscription for cloud access by following the instructions mentioned [here](https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html/red_hat_cloud_access_reference_guide/con-enable-subs) and activate the Red Hat Gold Images by following the instructions mentioned [here](https://access.redhat.com/documentation/en-us/red_hat_subscription_management/1/html/red_hat_cloud_access_reference_guide/using_red_hat_gold_images#con-azure-access). Once your Azure subscription is enabled, please follow this [link](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/redhat/byos) to accept the Marketplace terms for RHEL-BYOS image from your Azure subscription.

Note that in both the cases your RHSM account needs EAP entitlement to use the Enterprise Application Platform. You can get an evaluation account for EAP from [here](https://access.redhat.com/products/red-hat-jboss-enterprise-application-platform/evaluation).

Click [here](https://access.redhat.com/products/red-hat-subscription-management) to know more about RHSM.

## Prerequisites

1. Azure Subscription with the specified payment method (RHEL 8 is an [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RedHat.RedHatEnterpriseLinux80-ARM?tab=Overview) product and requires a payment method to be specified in the Azure Subscription). If you select the RHEL OS License type as BYOS (Bring-Your-Own-Subscription), please follow steps mentioned under section 'Licenses, Subscriptions and Costs'.

2. To deploy the template, you will need:

   - **Admin Username** and password/ssh key data which is an SSH RSA public key for your VM.

   - **JBoss EAP Username** and password
    
   - **RHSM Username** and password

## Deployment Steps

Build your environment with JBoss EAP 7.2 on top of RHEL 8.0 on Azure by clicking the **Deploy to Azure** button and fill in the following parameter values:

   - **Subscription** - Choose the appropriate subscription where you would like to deploy.

   - **Resource Group** - Create a new Resource Group or you can select an existing one.

   - **Location** - Choose the appropriate location for your deployment.

   - **Admin Username** - User account name for logging into your RHEL VM.

   - **Authentication Type** - Type of authentication to use on the Virtual Machine.

   - **Admin Password or SSH Key** - User account password/ssh key data which is an SSH RSA public key for logging into your RHEL VM.

   - **JBoss EAP Username** - Username for JBoss EAP Console.

   - **JBoss EAP Password** - User account password for JBoss EAP Console.

   - **RHEL OS License Type** - Choose the type of RHEL OS License from the dropdown options for deploying your Virtual Machine.
    
   - **RHSM Username** - Username for the Red Hat account.

   - **RHSM Password** - User account password for the Red Hat account.
   
   - **RHSM Pool ID for EAP** - Red Hat Subscription Manager Pool ID (Should have EAP entitlement)

   - **RHSM Pool ID for RHEL OS** - Red Hat Subscription Manager Pool ID (Should have RHEL entitlement). Mandartory if you select the BYOS RHEL OS License type. You can leave it blank if you select RHEL OS License type PAYG.

   - **Storage Replication** - Choose the Replication Strategy for your Storage account.

   - **VM Size** - Choose the appropriate size of the VM from the dropdown options.

   - Leave the rest of the parameter values (artifacts and Location) as is and accept the terms and conditions before clicking on Purchase.

## Deployment Time 

The deployment takes about 10 minutes to complete.

## Validation Steps

- Once the deployment is successful, go to the outputs section of the deployment to obtain the VM DNS name, App URLs and the Admin Console URL:

  ![alt text](images/template-output.png)

- Use the VM DNS name to access the VM and enter the VM username and password/ssh key, the "Admin Username" and "Admin Password/SSH Key" you provided before you deployed the template.

- Once you login into the VM, you can go through the *server.log* on JBoss EAP to see how Jgroup discovery works for clustering. Please enter the following command : 

  `cat /opt/rh/eap7/root/usr/share/wildfly/node1/log/server.log`

  ![alt text](images/ssh-command.png)

- When you look at one of the server logs ( i.e. node1 or node2 ), you should be able to identify the JGroups cluster members being added `Received new cluster view:`

  ![alt text](images/session-replication-logs.png)

- Paste the App URL that you copied from the output page in a browser to view the EAP Session Replication web page.
  
  ![alt text](images/eap-session.png)
  ![alt text](images/session-application-app.png)

- The web application displays the *Session ID*, *Session counter* and *Timestamp* (these are variables stored in the session that are replicated) and the container Private IP address that the web page and session is being hosted from. Clicking on the Increment Counter updates the session counter and clicking on Refresh will refresh the page.

- Now, click on the **Increment Counter**. The session counter will increase. Note that the session counter increases simultaneously on both App UIs.

  ![alt text](images/session-replication-increment.png)

- Paste the Admin Console URL that you copied from the output page in a browser to access the JBoss EAP Admin Console and enter the JBoss EAP Username and password to login.

## Support

For any support related questions, issues or customization requirements, please contact info@spektrasystems.com
