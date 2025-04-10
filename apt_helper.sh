#!/bin/bash

search_package() {
    local package_name=$1

    package_info=$(apt-cache search "$package_name" | grep "^$package_name")

    if [[ -z "$package_info" ]]; then
        echo "Package $package_name not found."
        exit 1
    fi

    echo "$package_info"

    read -p "Install $package_name? (y/n): " answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        apt update
        apt install -y "$package_name"
        if [ $? -eq 0 ]; then
            echo "$package_name installed successfully"
        else
            echo "$package_name failed to install"
        fi
    else
        echo "Not installing $package_name"
    fi
}

if [ -z "$1" ]; then
    echo "Usage: $0 <package-name>"
    exit 1
fi

search_package "$1"
