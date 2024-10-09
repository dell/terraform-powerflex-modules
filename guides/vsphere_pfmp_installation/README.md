# vSphere OVA Powerflex Manager Installation Guide

### Overview
*This configuration will be broken into 3 steps, each step will have either a configuration or README with manual steps the user needs to do.* 

## Step 1 Deploy EXSi OVAs
- Use the vsphere-ova-vm-deployment module to deploy all 4 VMs, the 3 nodes and the installer VM. These VMs can be found on the dell support site here: https://www.dell.com/support/home/en-us/product-support/product/scaleio/drivers

## Step 2 Setup VM interfaces
- Import the Entrust root certificate to the Vmware vCenter certificate store: https://www.dell.com/support/manuals/en-us/scaleio/pfx_p_software-install-upgrade-46x/add-entrust-root-certificate-to-the-vmware-vcenter-certificate-store?guid=guid-e9b530a7-2ac7-4e00-89cb-70a681a70c2a&lang=en-us . **Note: this only needs to be preformed once. If using the same vCenter for multiple clusters this step only needs to be preformed one time.**

- Follow these steps to set the IP addresses on all 4 of the VMs you deployed in step 1: https://www.dell.com/support/manuals/en-us/scaleio/pfx_p_software-install-upgrade-46x/configure-the-powerflex-management-platform-installer-networking-interface?guid=guid-2e62d072-8286-4313-96cd-6a6203029991&lang=en-us

- Set the property values for the **PFMP_Config.json**. This will be the IPAddress/Hostnames of your 3 nodes as well as information about the IPs needed for your management UI. For more information check out this: https://www.dell.com/support/manuals/en-us/scaleio/pfx_p_software-install-upgrade-46x/deploy-the-powerflex-management-platform-cluster?guid=guid-8ad88b8b-2ab7-4c46-a077-512749a059d2&lang=en-us. **Note: you do not need to do the steps in the above KB articial just set the *PFMP_Config.json* with the values as described. An example of this JSON file is in the examples/vsphere_pfmp_installation/PFMP_Config.json**

## Step 3 Install the Powerflex Manager
- Use the vsphere_pfmp_installation module to install the Powerflex Manager