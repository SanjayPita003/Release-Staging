# Bash Script README

## Overview

This Bash script is designed to perform specific tasks related to a release build. It includes functions for updating parameters, displaying parameters, pre-staging activities, and executing additional SSH commands.

## Machine Details

- **Remote Host:** `10.202.5.122`
- **Remote Port:** `22`
- **Remote User:** `psccqa`
- **Private Key Path:** `/path/to/your/private/key`

## Default Values

- **Release Build:** `S20`
- **Release Letter:** `T`
- **Build Number:** `17`
- **Previous Release Letter:** `U`
- **2 Releases Prior Letter:** `T`
- **Host:** `\\SED1`
- **Database:** `020.36`
- **Prefix Letter:** `S`
- **New Disk:** `$DATA1`
- **Old Disk:** `$DATA2`
- **Port:** `13000`
- **CTCWS:** `36.64`
- **TMA:** `21.2`

## Usage

1. Run the script: `./your_script_name.sh`
2. Follow the prompts to update parameters if desired.

## Script Execution

```bash
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

# Perform additional SSH commands
echo "Performing Additional SSH Commands:"
additional_ssh_commands

## Setting Up SSH Key Pair for Jenkins Job
1. **Generate SSH Key Pair:**
   - On the machine where you run the Jenkins job, generate an SSH key pair using the following command:
     ```bash
     ssh-keygen -t rsa -b 2048
     ```
   - Make sure to leave the passphrase empty for automated scripts.

2. **Copy the Public Key to the Remote Server:**
   - Copy the public key to the `~/.ssh/authorized_keys` file on the target machine.
     ```bash
     ssh-copy-id -i ~/.ssh/id_rsa.pub user@10.202.5.114
     ```
     Replace "user" with your actual username on the remote machine.

3. **Test SSH Connection:**
   - Ensure that you can now SSH to the remote machine without entering a password.
     ```bash
     ssh user@10.202.5.114
     ```
     This should log you in without prompting for a password.

4. **Modify Jenkins Job:**
   - In the Jenkins job configuration, use the Jenkins Credential feature to manage the SSH private key.
   - Create a new Jenkins Credential of type "Secret File" and upload the private key generated in step 1.
   - In your Jenkins job, use the SSH private key credential in the SSH build step.
