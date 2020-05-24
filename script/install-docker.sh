#!/usr/bin/env bash

# ______________________________________________________
# Bash script to install docker on target system
#
# @file 	install-docker.sh
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
#
# Notes:
# Currently only Debian, Ubuntu, CentOS and Fedora supported. (centos and fedora not tested)
# ______________________________________________________


if [[ $(which docker) && $(docker --version) ]]; then
    echo "Docker is already installed, verifying current user is in docker group"
    if groups $username | grep -q '\bdocker\b'; then
        echo "In docker group."
    else
        read -p "Current user is not in docker group. Do you want to add it to docker group? [Yy/Nn]? " -n 1 -r
        echo  
        if [[ $REPLY =~ ^[Yy]$ ]] ; then
            if $(sudo usermod -a -G docker $(whoami)) ; then
                newgrp docker
                echo "Added current user to docker group."
                echo "The previously spawn shell instances will still show the old groups, a logout/login"
                echo "is recommended to make changes effective."
            else
                echo "Failed adding $(whoami) to docker group."
            fi
        fi
    fi
  else

    echo "Docker is not installed in your system."
    echo "In order to use development container provided by hadouken,"
    echo "Docker is needed to be installed into your system."
    read -p "Do you want to install Docker [Yy/Nn]? " -n 1 -r
    echo 
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        echo "Determining OS information"
        . /etc/os-release
        case "$ID" in
        "debian")
            sudo apt-get update &&
            sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common &&
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - &&
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" &&
            sudo apt-get update &&
            sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose
            ;;
        "ubuntu" )
            sudo apt-get update &&
            sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common &&
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
            sudo apt-get update &&
            sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose
            ;;
        "centos" )
            sudo yum install -y yum-utils &&
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose
            ;;
        "fedora" )
            sudo yum install -y yum-utils &&
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose
            ;;
        *)
            echo "Operating system $ID not supported. Please install manually."
            ;;
        esac

        sudo usermod -a -G docker $(whoami)
        sudo systemctl enable docker
        sudo systemctl start docker
    else
        echo "Docker installation skipped. You can always install it later by running this script, or manually."
    fi
fi