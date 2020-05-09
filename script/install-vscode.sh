#!/usr/bin/env bash

# ______________________________________________________
# Bash script to install vscode to the system.
#
# @file 	install-vscode.sh
# @author   Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

declare -a vscode_alts=(code code-insiders)

for i in "${vscode_alts[@]}";
do
    echo $i
    if [[ $(which $i) && $($i --version) ]]; then
        VSCODE_ALREADY_INSTALLED=1
        break;
    fi
done

if ! [[ -v VSCODE_ALREADY_INSTALLED ]] ; then
    echo "Visual studio code is not installed in your system."
    echo "Albeit you can use other code editors and IDE's,"
    echo "it is highly recommended to use hadouken together with vscode."
    read -p "Do you want to install Visual Studio Code [Yy/Nn]? " -n 1 -r
    echo  
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        . /etc/os-release
        case "$ID" in
        "debian" | "ubuntu" )
            # TODO: Check if repo already exist
            # The abomination below reports the current apt repositories available.
            # grep -hv -E '(#)' /etc/apt/sources.list /etc/apt/sources.list.d/* | grep \s | grep -Eo '(http|https)://[^/"]+' | cut -d ' ' -f 1 | uniq
            echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list &&
            curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&
            sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg &&
            sudo apt-get update &&
            sudo apt-get -y install code 
            ;;
        "centos" )
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo
            sudo yum install -y code
            ;;
        *)
            echo "Operating system $ID not supported. Please install manually."
            ;;
        esac
    
    fi
fi