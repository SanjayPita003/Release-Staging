#!/bin/bash

# Machine details
remote_host="10.202.5.114"
remote_port="22"
remote_user="psccqa"
private_key_path="/path/to/your/private/key"


# Default values
release_build="S20"
release_letter="T"
build_number="17"
prev_release_letter="U"
two_releases_prior_letter="T"
host="\\SED1"
database="020.36"
prefix_letter="S"
new_disk="$DATA1"
old_disk="$DATA2"
port="13000"
ctcws="36.64"
tma="21.2"

# Function to display current parameters
display_parameters() {
    echo "Release Build: $release_build"
    echo "Release Letter: $release_letter"
    echo "Build Number: $build_number"
    echo "Previous Release Letter: $prev_release_letter"
    echo "2 Releases Prior Letter: $two_releases_prior_letter"
    echo "Host: $host"
    echo "Database: $database"
    echo "Prefix Letter: $prefix_letter"
    echo "New Disk: $new_disk"
    echo "Old Disk: $old_disk"
    echo "Port: $port"
    echo "CTCWS: $ctcws"
    echo "TMA: $tma"
}

# Function to update parameters based on user inputs
update_parameters() {
    read -p "Enter Release Build [$release_build]: " input
    release_build=${input:-$release_build}

    read -p "Enter Release Letter [$release_letter]: " input
    release_letter=${input:-$release_letter}

    read -p "Enter Build Number [$build_number]: " input
    build_number=${input:-$build_number}

    read -p "Enter Previous Release Letter [$prev_release_letter]: " input
    prev_release_letter=${input:-$prev_release_letter}

    read -p "Enter 2 Releases Prior Letter [$two_releases_prior_letter]: " input
    two_releases_prior_letter=${input:-$two_releases_prior_letter}

    read -p "Enter Host [$host]: " input
    host=${input:-$host}

    read -p "Enter Database [$database]: " input
    database=${input:-$database}

    read -p "Enter Prefix Letter [$prefix_letter]: " input
    prefix_letter=${input:-$prefix_letter}

    read -p "Enter New Disk [$new_disk]: " input
    new_disk=${input:-$new_disk}

    read -p "Enter Old Disk [$old_disk]: " input
    old_disk=${input:-$old_disk}

    read -p "Enter Port [$port]: " input
    port=${input:-$port}

    read -p "Enter CTCWS [$ctcws]: " input
    ctcws=${input:-$ctcws}

    read -p "Enter TMA [$tma]: " input
    tma=${input:-$tma}
}

# Function to perform pre-staging activities
prestage_activities() {
    # SSH commands using dynamically set parameters
    ssh wil-trng1 ls -ld "/L/ctc_data/ctc_data.${release_build}.${database}"
    ssh wil-trng2 ls -ld "/L/ctc_data/ctc_data.${release_build}.${database}"

    ssh wil-trng1 ls -ld "/L/ctcws/ctcws.${ctcws}"
    ssh wil-trng2 ls -ld "/L/ctcws/ctcws.${ctcws}"

    ssh wil-trng1 ls -ld "/L/gds/tma.${tma}"
    ssh wil-trng2 ls -ld "/L/gds/tma.${tma}"
}

# Function to perform additional SSH commands
additional_ssh_commands() {
    # SSH commands for PRODSE.USER1
    ssh PRODSE.USER1@SED1 "EMANT TP1; DE"

    # SSH commands for TRAIN.TRNING
    ssh TRAIN.TRNING@SED1 "EMANT TT2; DE"

    # SSH commands for RC.MGR
    ssh RC.MGR@SED1 "EMANT TRA; DE"

    # SSH commands for RX.FER
    ssh RX.FER@SED1 "VOLUME $SYSTEM.EMANT; PURGE *; FI"
}

# Function to perform additional SSH commands for profile setup
additional_profile_setup() {
    # SSH commands for RC.MGR
    ssh RC.MGR@SED1 "VOLUME $AUDIT.EMANTS; BINSTALL; INSTALL EMAN{$release_letter}S EMAN{$release_letter}"

    # SSH commands for RC.MGR
    ssh RC.MGR@SED1 "VOLUME $AUDIT.EMANT; PURGE PROFILES; FUP DUP EMANT.PROFILES,*; EDIT PROFILES"

    # SSH commands for RX.FER@SED1
    ssh RX.FER@DEV2 "VOLUME $EMAN.EMAN{$release_letter}; EDIT PROFILES; LA; ADD <line number>"

    # Paste the text copied previously. Review and save changes.

    # SSH commands for RX.FER@DEV2
    ssh RX.FER@DEV2 "EMAN{$release_letter} {$release_letter}RH; RE {$release_letter}RA ALL"

}

# Display default parameters
echo "Default Parameters:"
display_parameters

# Ask user if they want to update parameters
read -p "Do you want to update parameters? (y/n): " choice

# If the user chooses to update, call the update_parameters function
if [ "$choice" == "y" ]; then
    update_parameters
fi

# Display updated parameters
echo "Updated Parameters:"
display_parameters

# Perform pre-staging activities
echo "Performing Pre-staging Activities:"
prestage_activities

# Perform additional profile setup
echo "Performing Additional Profile Setup:"
additional_profile_setup

# Perform additional SSH commands
echo "Performing Additional SSH Commands:"
additional_ssh_commands
