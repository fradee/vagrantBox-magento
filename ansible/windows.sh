#!/usr/bin/env bash
CHECK_ANSIBLE=$(which ansible)
VERSION_UBUNTU=$(lsb_release -rs)

if [ "$VERSION_UBUNTU" == "16.04" ]
then
    echo ubuntu:ubuntu | chpasswd
fi

if [ "$CHECK_ANSIBLE" != "/usr/bin/ansible" ]
then
    # Update Repositories
    if [ "$VERSION_UBUNTU" == "14.04" ]
        then
    sudo add-apt-repository ppa:fkrull/deadsnakes-python2.7
    fi
    sudo apt-get update
    sudo apt-get -y upgrade

    if [ "$VERSION_UBUNTU" == "14.04" ];
    then
        sudo apt-get install -y software-properties-common
    else if [ "$VERSION_UBUNTU" == "12.04" ]
            then
                sudo apt-get install -y python-software-properties
    #        else if [ "$VERSION_UBUNTU" == "16.04" ]
    #                then

    #             fi
        fi
    fi
    # Add Ansible Repository & Install Ansible
    sudo add-apt-repository -y ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible --allow-unauthenticated
    sudo ansible-galaxy install -r /vagrant/ansible/requirements.yml
fi

# Setup Ansible for Local Use and Run
cp /vagrant/ansible/inventory/vagrant /etc/ansible/hosts -f
chmod 666 /etc/ansible/hosts
if [ "$VERSION_UBUNTU" == "16.04" ]
    then
    cat /etc/ssh/ssh_host_rsa_key.pub >> /home/ubuntu/.ssh/authorized_keys
else
    cat /etc/ssh/ssh_host_rsa_key.pub >> /home/vagrant/.ssh/authorized_keys
fi
sudo ansible-playbook /vagrant/ansible/playbook_vagrant.yml -e hostname=$1 --connection=local #-vvv