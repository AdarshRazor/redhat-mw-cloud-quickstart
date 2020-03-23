# JBoss EAP 7.2 on RHEL 7.7 on Azure VMSS (clustered, multi-VM)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSpektraSystems%2Fredhat-mw-cloud-quickstart%2Fmaster%2Fjboss-eap-clustered-rhel-VMSS%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

`Tags: JBoss, EAP, Red Hat,EAP7, Load Balancer`

<!-- TOC -->

1. [Solution Overview ](#solution-overview)
2. [Template Solution Architecture ](#template-solution-architecture)
3. [Licenses and Costs ](#licenses-and-costs)
4. [Prerequisites](#prerequisites)
5. [Deployment Steps](#deployment-steps)
6. [Deployment Time](#deployment-time)
7. [Post Deployment Steps](#post-deployment-steps)

<!-- /TOC -->

## Solution Overview

JBoss EAP is an open source platform for highly transactional, web-scale Java applications. EAP combines the familiar and popular Jakarta EE specifications with the latest technologies, like Microprofile, to modernize your applications from traditional Java EE into the new world of DevOps, cloud, containers, and microservices. EAP includes everything needed to build, run, deploy, and manage enterprise Java applications in a variety of environments, including on-premise, virtual environments, and in private, public, and hybrid clouds.

This template creates two JBoss EAP Instances running inside a VNet and each server is in it’s own subnet. Both the servers are added to the backend pool of a Load Balancer.

## Template Solution Architecture

This template creates all of the compute resources to run EAP 7.2 on top of RHEL 7.7 VMs which are added to the backend pool of a Load Banlancer. Following are the resources deployed:

- 2 RHEL 7.7 VMs
- 1 Load balancer
- Public DNS
- Virtual Network with 2 subnets
- EAP 7.2 on RHEL 7.7
- Sample application deployed to JBoss EAP 7
- Security Configuration

Following is the Architecture :
<img src="image/arch.png" width="800">

To learn more about JBoss Enterprise Application Platform, check out:
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.2/

## Licenses and Costs 

This uses RHEL 7.7 image which is a PAY AS YOU GO image and doesn't require the user to license it; it will be licensed automatically after the instance is launched the first time and the user will be charged hourly in addition to Microsoft's Linux VM rates. Click [here](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/#red-hat) for pricing details.

## Prerequisites

1. Azure Subscription with specified payment method (RHEL 7.7 is an [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RedHat.RedHatEnterpriseLinux77-ARM?tab=Overview) product and requires payment method to be specified in Azure Subscription)

2. To deploy the template, you will need to:

    - Choose an admin username and password/ssh key for your VM.  

    - Choose a EAP user name and password to enable the EAP manager UI and deployment method.
    
## Deployment Steps

Build your environment with EAP 7.2 on top of RHEL 7.7 which is added to the backend pool of the Load Balancer on Azure in a few simple steps:  
1. Launch the Template by clicking Deploy to Azure button.  
2. Fill in the following parameter values and accept the terms and condition before clicking on Purchase.

    - **Subscription** - Choose the right subscription where you would like to deploy.

    - **Resource Group** - Create a new Resource group or you can select an existing one.

    - **Location** - Choose the right location for your deployment.

    - **Admin Username** - User account name for logging into your RHEL VM.
    
    - **Authentication Type** - Type of authentication to use on the Virtual Machine.

    - **Admin Password or Key** - User account password/ssh key for logging into your RHEL VM.

    - **EAP Username** - User name for EAP Console.

    - **EAP Password** - User account password for EAP Console.

    - Leave the rest of the Parameter Value as it is and proceed.
    
## Deployment Time 

The deployment takes approx. 10 minutes to complete.

## Post Deployment Steps

- Once the deployment is successful, go to the VM and copy the Public IP of the VM which is the Public IP of the Load Balancer.
- Open a web browser and go to **http://<PUBLIC_HOSTNAME>** and you should see the web page:

<img src="image/eap.png" width="800">

- If you want to access the administration console go to **http://<PUBLIC_HOSTNAME>:9990** and enter the EAP Username and Password:

<img src="image/eap-admin-console.png" width="800">

- If you want to access the LB App UI console go to  **http://<LB_PUBLICIP_DNS/eap-session-replication/** and if you want to access the VM App UI console go to **http://<VM_PUBLICIP_DNS>:9990/eap-session-replication/**. This fetches the VM private IP and updates the session counter upon clicking on the Increament counter. Note that the session ID of all the 3 App UI console is different.

<img src="image/eap-session-rep.png" width="800">
