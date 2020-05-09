#!/usr/bin/env bash

# ______________________________________________________
# Bash script to install required vscode extensions
# for hadouken
#
# @file 	install-vscode-extensions.sh
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
declare -a vscode_required_extensions=(ms-vscode-remote.remote-containers)

prompt(){
    echo "Following visual studio code extensions are needed for hadouken;"
    echo 
    printf '%s\n' "${vscode_required_extensions[@]}"
    echo 
    read -p "Do you want to install them? [Yy/Nn]? " -n 1 -r
    echo  
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        VSX_PROMPT_CONFIRMED=1
    fi
}

for i in "${vscode_alts[@]}";
do
    if [[ $(which $i) && $($i --version) ]]; then
        for x in ${vscode_required_extensions[@]}
        do
            if $i --list-extensions | grep -q "\b${x}\b" ; then
                echo "Extension $x already installed, skipping"
            else
                if [[ -v VSX_PROMPT_CONFIRMED ]]; then
                    prompt
                    if [[ -v VSX_PROMPT_CONFIRMED ]]; then
                        break
                    fi
                fi
                echo "Installing extension $x .."
                $i --install-extension $x
            fi
        done
        break;
    fi
done