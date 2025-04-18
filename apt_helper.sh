#!/bin/bash

check_lock() {
    if lsof /var/lib/dpkg/lock-frontend > /dev/null || lsof /var/lib/apt/lists/lock > /dev/null; then
        echo "Another instance of dpkg or apt is holding the lock. Wait until it's done before running this script."
        echo "To see which process is holding the lock, run the following:"
        echo "    lsof /var/lib/dpkg/lock-frontend"
        echo "    lsof /var/lib/apt/lists/lock"
        exit 1
    fi
}

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
        sudo apt-get update
        sudo apt-get install -y "$package_name"
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

check_lock

search_package "$1"
