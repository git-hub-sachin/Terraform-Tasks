# Multi-Region AWS VPC Setup with Terraform

This Terraform project sets up a multi-region AWS infrastructure with two VPCs, private EC2 instances, a bastion host, and VPC peering. The setup allows SSH and ping access from the bastion host to private instances in both regions.

## Architecture Overview

- **VPC-1 (Region 1)**:
  - CIDR: `10.0.0.0/16`
  - Public Subnet: `10.0.2.0/24` (for bastion host)
  - Private Subnet: `10.0.1.0/24` (for private EC2)
  - Bastion Host: Public EC2 instance for SSH access
  - Private EC2: Isolated instance accessible via bastion

- **VPC-2 (Region 2)**:
  - CIDR: `10.1.0.0/16`
  - Private Subnet: `10.1.1.0/24` (for private EC2)
  - Private EC2: Accessible via bastion in VPC-1 through VPC peering

- **VPC Peering**: Connects VPC-1 and VPC-2 for cross-region communication.

- **Security**: 
  - Bastion allows SSH from anywhere (configurable).
  - Private EC2s allow SSH and ICMP (ping) from bastion subnet (VPC-1) or VPC-1 CIDR (VPC-2).

## Project Structure

```
terraform_project/
├── main.tf              # Main configuration file
├── variables.tf         # Variable definitions
├── outputs.tf           # Outputs
├── modules/
│   ├── vpc/             # VPC module (VPC, subnets, route tables)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc_peering/     # VPC peering module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/             # EC2 instance module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
└── README.md            # This file
```

## Prerequisites

- **Terraform**: Version 1.10.5 installed.
- **AWS CLI**: Configured with credentials (`aws configure`).
- **SSH Key Pair**: Created in both regions (e.g., `my-key-pair`) with the private key (`.pem`) file available locally.


## Usage

### Accessing Instances

1. **SSH into Bastion Host**:
   ```bash
   ssh -i <key.pem> ec2-user@<bastion_public_ip>
   ```

2. **Upload Private Key to Bastion**:
   From your local machine:
   ```bash
   scp -i <key.pem> <key.pem> ec2-user@<bastion_public_ip>:~/.ssh/
   ```
   On the bastion:
   ```bash
   chmod 400 ~/.ssh/<key.pem>
   ```

3. **Ping Private Instances**:
   - VPC-1:
     ```bash
     ping <private_ec2_vpc1_ip>
     ```
   - VPC-2:
     ```bash
     ping <private_ec2_vpc2_ip>
     ```

4. **SSH into Private Instances**:
   - VPC-1:
     ```bash
     ssh -i ~/.ssh/<key.pem> ec2-user@<private_ec2_vpc1_ip>
     ```
   - VPC-2:
     ```bash
     ssh -i ~/.ssh/<key.pem> ec2-user@<private_ec2_vpc2_ip>
     ```

### Network Flow

- **Bastion to VPC-1 Private EC2**: Direct within the same VPC via private subnet.
- **Bastion to VPC-2 Private EC2**: Via VPC peering (VPC-1 CIDR `10.0.0.0/16` to VPC-2 CIDR `10.1.0.0/16`).


## Customization

- **Regions**: Modify `region_1` and `region_2` in `variables.tf`.
- **CIDR Blocks**: Adjust VPC and subnet CIDRs in `main.tf`.
- **Security**: Restrict `allowed_ssh_cidr` for the bastion (e.g., `"203.0.113.0/32"`) in `main.tf`.
- **Instance Types**: Update `instance_type` in the `ec2` module calls.

## Troubleshooting

- **Ping Fails**:
  - Verify security groups allow ICMP from `10.0.2.0/24` (VPC-1) and `10.0.0.0/16` (VPC-2).
  - Check route tables for peering routes.
- **SSH Fails**:
  - Ensure the private key permissions are `chmod 400`.
  - Confirm `allowed_ssh_cidr` matches the bastion’s subnet or VPC-1 CIDR.
- **Peering Issues**:
  - Validate the peering connection is active in AWS Console (VPC > Peering Connections).
- **Debugging**:
  - Use `traceroute` from the bastion:
    ```bash
    traceroute <private_ec2_vpc2_ip>
    ```

## Outputs

- `bastion_public_ip`: Public IP of the bastion host.
- `private_ec2_vpc1_ip`: Private IP of the EC2 in VPC-1.
- `private_ec2_vpc2_ip`: Private IP of the EC2 in VPC-2.
- `vpc_1_id`, `vpc_2_id`: VPC IDs.
- `peering_connection_id`: VPC peering connection ID.

