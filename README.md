# Automated AWS EC2 Provisioning with Terraform & Ansible

## Project Overview

This project automates the provisioning and configuration of an AWS EC2 instance using **Terraform** and **Ansible**. Terraform is used to create the infrastructure (EC2 instance and SSH key pair), while Ansible handles the server configuration by installing and starting **Nginx**.

## Features

- **Infrastructure as Code (IaC)** using Terraform to provision EC2 instances.
- **Automated Server Configuration** with Ansible (Nginx installation and startup).
- **Secure SSH Access** by generating and using an SSH key pair.
- **Modular & Reproducible** deployment for consistent environments.
- **Easy Teardown** using Terraform to remove all deployed resources.

## Prerequisites

Before running this project, ensure you have the following installed:

1. **Terraform** – [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
2. **AWS CLI** – [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
3. **Ansible** – [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
4. **AWS Account** – Ensure you have AWS credentials configured (`aws configure`).
5. **SSH Key Pair** – A valid SSH key for secure access.

## Project Structure

```
├── main.tf         # Terraform configuration for AWS EC2 & SSH key
├── inventory.ini   # Ansible inventory file with EC2 details
├── playbook.yml    # Ansible playbook for configuring Nginx
└── README.md       # Project documentation
```

## Terraform: Provisioning the AWS EC2 Instance

### 1. Initialize Terraform

```sh
terraform init
```

### 2. Plan the Deployment

```sh
terraform plan
```

### 3. Apply Terraform Configuration

```sh
terraform apply -auto-approve
```

### 4. Retrieve Instance Details

After deployment, Terraform outputs the **public IP** of the EC2 instance:

```sh
terraform output instance_public_ip
```

## Ansible: Configuring EC2 with Nginx

### 1. Update the Inventory File

Modify `inventory.ini` with the Terraform-generated instance IP:

```ini
[web]
{{ ec2_instance_ip }} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ansible-key
```

### 2. Test the Connection

Ensure Ansible can connect to the EC2 instance:

```sh
ansible -i inventory.ini web -m ping
```

Expected output:

```
{{ ec2_instance_ip }} | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 3. Deploy Nginx on EC2

Run the playbook:

```sh
ansible-playbook -i inventory.ini playbook.yml
```

### 4. Verify Deployment

Check if Nginx is running by accessing:

```
http://{{ ec2_instance_ip }}
```

Or SSH into the instance:

```sh
ssh -i ~/.ssh/ansible-key ec2-user@{{ ec2_instance_ip }}
sudo systemctl status nginx
```

## Destroying Resources

To remove all deployed resources and avoid costs:

```sh
terraform destroy -auto-approve
```

