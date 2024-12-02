#!/usr/bin/env bash
echo "${private_key}" > /home/id_rsa.pem
sudo useradd pflex-user -m
echo 'pflex-user       ALL=(ALL)      NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
sudo mkdir -p /var/pfmp/keys
chmod 400 /home/id_rsa.pem
ssh-keygen -f /home/id_rsa.pem -y > /tmp/id_rsa.pub
sudo -H -u pflex-user bash -c 'mkdir -p ~pflex-user/.ssh'
sudo -H -u pflex-user bash -c 'touch ~pflex-user/.ssh/authorized_keys'
sudo -H -u pflex-user bash -c 'cat /tmp/id_rsa.pub >> ~pflex-user/.ssh/authorized_keys'
sudo rm -rf /tmp/id_rsa.pub
sudo mv /home/id_rsa.pem /var/pfmp/keys/id_rsa
