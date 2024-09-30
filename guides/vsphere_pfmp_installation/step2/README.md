# Step 2 Manual Steps

### Overview
*Do the following manual steps after the deployment of the OVAs in step 1*

1. Import the Entrust root certificate to the Vmware vCenter certificate store: https://www.dell.com/support/manuals/en-us/scaleio/pfx_p_software-install-upgrade-46x/add-entrust-root-certificate-to-the-vmware-vcenter-certificate-store?guid=guid-e9b530a7-2ac7-4e00-89cb-70a681a70c2a&lang=en-us . **Note: this only needs to be preformed once. If using the same vCenter for multiple clusters this step only needs to be preformed one time.**

2. Follow these steps to set the IP addresses on all 4 of the VMs you deployed in step 1: https://www.dell.com/support/manuals/en-us/scaleio/pfx_p_software-install-upgrade-46x/configure-the-powerflex-management-platform-installer-networking-interface?guid=guid-2e62d072-8286-4313-96cd-6a6203029991&lang=en-us

3. Set the property values for the **step3/PFMP_Configuration.json**. This will be the IPAddress/Hostnames of your 3 nodes as well as information about the IPs needed for your management UI. For more information check out this: https://www.dell.com/support/manuals/en-us/scaleio/pfx_p_software-install-upgrade-46x/deploy-the-powerflex-management-platform-cluster?guid=guid-8ad88b8b-2ab7-4c46-a077-512749a059d2&lang=en-us. **Note: you do not need to do the steps in the above KB articial just set the *PFMP_Config.json* with the values as described.**