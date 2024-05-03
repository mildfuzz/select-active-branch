#!/bin/bash

input=$1

# Set the IFS variable to comma
IFS=',' read -ra USERNAME_LIST <<< "$input"



select option in "${USERNAME_LIST[@]}" "Quit"; do
    case $option in
        "Quit")
            echo "Exiting..."
            exit 255
            ;;
        *)
            echo "$option"
            exit 0;
            ;;
    esac
done

