# Azure Load Balancer with Virtual Machine Scale Set - Terraform

A production-ready Terraform infrastructure-as-code project that deploys an Azure Load Balancer with Virtual Machine Scale Sets (VMSS) for scalable web application hosting.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Modules](#modules)
- [Deployment](#deployment)
- [Accessing the Application](#accessing-the-application)
- [Scaling](#scaling)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project creates a complete Azure infrastructure for hosting scalable web applications using:

- **Azure Load Balancer**: Distributes traffic across multiple VM instances
- **Virtual Machine Scale Sets**: Auto-scales based on demand
- **Virtual Network**: Isolated network infrastructure with multiple subnets
- **Network Security Groups**: Controls inbound/outbound traffic
- **Ubuntu Linux VMs**: Running NGINX web servers

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Azure Load Balancer                  │
│                  (Public IP: Static)                     │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐      ┌────────▼────────┐
│   VMSS Instance│      │   VMSS Instance │
│   (Ubuntu 22.04)│      │   (Ubuntu 22.04)│
│   NGINX Server │      │   NGINX Server  │
└────────────────┘      └─────────────────┘
        │                         │
        └────────┬─────────────────┘
                 │
        ┌────────▼────────┐
        │  Virtual Network │
        │  (Multiple Subnets)│
        └─────────────────┘
```

## ✅ Prerequisites

- **Terraform**: >= 1.0.0
- **Azure CLI**: Latest version
- **Azure Subscription**: Active subscription with appropriate permissions
- **Service Principal**: For authentication (credentials in [providers.tf](providers.tf))

## 📁 Project Structure

```
.
├── main.tf                          # Root configuration
├── variables.tf                     # Root variables
├── providers.tf                     # Provider configuration
├── terraform.tfvars                 # Variable values (gitignored)
├── .gitignore                       # Git ignore rules
├── .terraform.lock.hcl             # Provider version lock
│
└── modules/
    ├── general/
    │   └── resourcegroup/
    │       ├── main.tf              # Resource group module
    │       ├── variables.tf
    │       └── outputs.tf
    │
    ├── networking/
    │   ├── vnet/
    │   │   ├── main.tf              # Virtual network, subnets, NSG
    │   │   ├── variables.tf
    │   │   └── output.tf
    │   │
    │   └── loadbalancer/
    │       ├── main.tf              # Load balancer configuration
    │       ├── variables.tf
    │       └── outputs.tf
    │
    └── Compute/
        ├── scalesets/
        │   ├── main.tf              # VMSS configuration
        │   ├── variables.tf
        │   ├── output.tf
        │   └── cloudinit            # Cloud-init script for NGINX
        │
        └── VirtualMachines/
            ├── main.tf              # Individual VM configuration
            ├── variables.tf
            ├── outputs.tf
            ├── cloudinit.yml        # Cloud-init for VMs
            └── copyfiles.tf         # File provisioning
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd "Azure Load Balancer - Scale Set"
```

### 2. Configure Variables

Create a `terraform.tfvars` file:

```hcl
resource_group_name = "your-resource-group"
location            = "East US"
vnet_name           = "app-vnet"
vnet_address_prefix = "10.0.0.0/16"
vnet_subnet_count   = 2
public_ip_address_count = 2
network_interface_count = 2
vm_count            = 2
number_of_machines  = 2

network_security_group_rules = [
  {
    priority               = 100
    destination_port_range = "22"
  },
  {
    priority               = 200
    destination_port_range = "80"
  }
]
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan -out=main.tfplan
```

### 5. Apply the Configuration

```bash
terraform apply main.tfplan
```

## ⚙️ Configuration

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `resource_group_name` | `string` | Name of the Azure resource group |
| `location` | `string` | Azure region (e.g., "East US") |
| `vnet_name` | `string` | Virtual network name |
| `vnet_address_prefix` | `string` | VNet CIDR block (e.g., "10.0.0.0/16") |
| `vnet_subnet_count` | `number` | Number of subnets to create |
| `vm_count` | `number` | Number of individual VMs |
| `number_of_machines` | `number` | Number of machines in load balancer pool |
| `network_security_group_rules` | `list(object)` | NSG rules configuration |

### Default Credentials

**⚠️ Security Warning**: Change these default credentials in production!

- **Username**: `linuxadmin` (Scale Sets) / `adminuser` (VMs)
- **Password**: `Azure@1234`

## 📦 Modules

### 1. Resource Group Module

**Location**: [`modules/general/resourcegroup`](modules/general/resourcegroup)

Creates the Azure resource group for all resources.

### 2. Network Module

**Location**: [`modules/networking/vnet`](modules/networking/vnet)

Creates:
- Virtual Network with configurable address space
- Multiple subnets (dynamically calculated using `cidrsubnet`)
- Public IP addresses (static allocation)
- Network interfaces
- Network Security Group with custom rules

### 3. Load Balancer Module

**Location**: [`modules/networking/loadbalancer`](modules/networking/loadbalancer)

Configures:
- Public-facing Azure Load Balancer
- Backend address pool
- Health probes (TCP port 80)
- Load balancing rules

### 4. Scale Sets Module

**Location**: [`modules/Compute/scalesets`](modules/Compute/scalesets)

Deploys:
- Linux Virtual Machine Scale Set
- Ubuntu 22.04 LTS instances
- Auto-configured with NGINX via cloud-init
- Integrated with load balancer backend pool

### 5. Virtual Machines Module

**Location**: [`modules/Compute/VirtualMachines`](modules/Compute/VirtualMachines)

Creates individual VMs with:
- Custom web pages
- NGINX installation
- SSH provisioning support

## 🚢 Deployment

### Step-by-Step Deployment

1. **Validate Configuration**
   ```bash
   terraform validate
   ```

2. **Format Code**
   ```bash
   terraform fmt -recursive
   ```

3. **Plan Infrastructure**
   ```bash
   terraform plan -out=main.tfplan
   ```

4. **Apply Changes**
   ```bash
   terraform apply main.tfplan
   ```

5. **Verify Outputs**
   ```bash
   terraform output
   ```

### Deployment Time

Typical deployment time: **5-10 minutes**

## 🌐 Accessing the Application

After successful deployment:

1. **Get Load Balancer Public IP**
   ```bash
   terraform output
   ```
   Or check in Azure Portal: Resource Group → Load Balancer → Frontend IP

2. **Access the Application**
   ```bash
   curl http://<LOAD_BALANCER_IP>
   ```
   Or open in browser: `http://<LOAD_BALANCER_IP>`

3. **Test Load Distribution**
   Refresh multiple times to see different backend instances serving requests.

## 📈 Scaling

### Manual Scaling

Edit the `instances` parameter in [`modules/Compute/scalesets/main.tf`](modules/Compute/scalesets/main.tf):

```hcl
resource "azurerm_linux_virtual_machine_scale_set" "scaleset" {
  # ...existing code...
  instances = 3  # Change from 2 to 3
  # ...existing code...
}
```

Then apply:
```bash
terraform apply
```

### Auto-Scaling (Future Enhancement)

To implement auto-scaling, add an `azurerm_monitor_autoscale_setting` resource.

## 🧹 Cleanup

### Destroy All Resources

```bash
terraform destroy
```

Confirm with `yes` when prompted.

### Selective Resource Destruction

```bash
terraform destroy -target=module.scalesets
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Authentication Errors

**Error**: `Error building AzureRM Client: obtain subscription()`

**Solution**: Verify service principal credentials in [`providers.tf`](providers.tf)

```bash
az login --service-principal \
  --username <client-id> \
  --password <client-secret> \
  --tenant <tenant-id>
```

#### 2. Quota Exceeded

**Error**: `Quota exceeded for CPU cores`

**Solution**: Request quota increase or use smaller VM SKU:
- Change `Standard_B1s` to `Standard_B1ls` in scale set configuration
- Or reduce `instances` count

#### 3. Network Connectivity Issues

**Error**: Cannot access application via load balancer

**Solution**: 
- Verify NSG rules allow port 80
- Check health probe status in Azure Portal
- Ensure NGINX is running on backend instances

#### 4. State Lock Issues

**Error**: `Error locking state`

**Solution**:
```bash
terraform force-unlock <LOCK_ID>
```

### Debug Mode

Enable detailed logging:

```bash
export TF_LOG=DEBUG
terraform apply
```

## 🔒 Security Best Practices

1. **Never commit credentials**: Use Azure Key Vault or environment variables
2. **Enable Network Security**: Review NSG rules regularly
3. **Use SSH Keys**: Replace password authentication with SSH keys
4. **Update credentials**: Change default passwords immediately
5. **Enable encryption**: Use encrypted disks for VMs
6. **Implement RBAC**: Use Azure role-based access control

## 📝 Notes

- The project uses **Terraform 4.9.0** for the Azure provider
- Cloud-init scripts automatically install and configure NGINX
- Subnets are dynamically created using `/24` CIDR blocks
- Load balancer uses static public IP allocation
- Health probes check TCP port 80

## 📄 License

This project is provided as-is for educational and demonstration purposes.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📧 Support

For issues and questions:
- Open an issue in the repository
- Check Azure documentation: https://docs.microsoft.com/azure
- Terraform documentation: https://www.terraform.io/docs

---

**Last Updated**: 2024
**Terraform Version**: >= 1.0.0
**Azure Provider Version**: 4.9.0
