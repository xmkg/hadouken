#!/bin/bash

# Bash script to install required vscode extensions
# for hadouken

# Author: Mustafa Kemal GILOR <mgilor@nettsi.com>

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