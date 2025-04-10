#!/bin/bash

search_package() {
    local package_name=$1

    package_info=$(apt search "$package_name" | grep -A 3 "^$package_name")

    if [[ -z "$package_info" ]]; then
        echo "Package $package_name not found."
        exit 1
    fi

    echo "$package_info"
}

if [ -z "$1" ]; then
    echo "Usage: $0 <package-name>"
    exit 1
fi

search_package "$1"
