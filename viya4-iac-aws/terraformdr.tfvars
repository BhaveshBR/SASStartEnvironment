# !NOTE! - These are only a subset of variables.tf provided for sample.
# Customize this file to add any variables from 'variables.tf' that you want
# to change their default values.

# ****************  REQUIRED VARIABLES  ****************
# These required variables' values MUST be provided by the User
prefix                                  = "sinbrvkdr"
location                                = "us-east-2" # e.g., "us-east-1"
ssh_public_key                          = "~/.ssh/id_rsa.pub"
create_static_kubeconfig                = true
# ****************  REQUIRED VARIABLES  ****************

# !NOTE! - Without specifying your CIDR block access rules, ingress traffic
#          to your cluster will be blocked by default.

# **************  RECOMENDED  VARIABLES  ***************
# Include CIDR ranges for the sas.com domains
#default_public_access_cidrs             = ["71.135.0.0/16"]  # e.g., ["123.45.6.89/32"]
# we allow access from the RACE VMWARE and RACE Azure clients network
default_public_access_cidrs         = ["149.173.0.0/16", "71.135.0.0/16", "20.242.50.43/32"]
# **************  RECOMENDED  VARIABLES  ***************

# Optional: tags for all tagable items in your cluster.
tags = { "resourceowner" = "sinbrvk" , "project_name" = "sasviya4aws" , "gel_project" = "PSGEL297" }

# Postgres config - By having this entry a database server is created. If you do not
#                   need an external database server remove the 'postgres_servers'
#                   block below.
#postgres_servers = {
#  default = {},
#}

# Bring your own existing resources
vpc_id  = "vpc-0da72db6c440725b8" # only needed if using pre-existing VPC
subnet_ids = {  # only needed if using pre-existing subnets
  "public" : ["subnet-0b04ddbb5faff11f7", "subnet-087afce4bd2fb161b"],
  "private" : ["subnet-02018ae17c7b822aa", "subnet-0c1b8ea6397ff2791"],
  "database" : ["subnet-054cc9d2f4cb47a74", "subnet-08c784a46f76c6f23"]
}
nat_id = "nat-0a08d0824ec63bbaf"
security_group_id = "sg-0603b16a1a1c2483f" # only needed if using pre-existing Security Group

## Cluster config
kubernetes_version                      = "1.21"
default_nodepool_node_count             = 1
default_nodepool_vm_type                = "m5.2xlarge"
default_nodepool_custom_data            = ""

## General
efs_performance_mode                    = "generalPurpose"
storage_type                            = "none"

## Cluster Node Pools config
node_pools = {
  cas = {
    "vm_type" = "m5.2xlarge"
    "cpu_type" = "AL2_x86_64"
    "os_disk_type" = "gp2"
    "os_disk_size" = 200
    "os_disk_iops" = 0
    "min_nodes" = 2
    "max_nodes" = 2
    "node_taints" = ["workload.sas.com/class=cas:NoSchedule"]
    "node_labels" = {
      "workload.sas.com/class" = "cas"
    }
    "custom_data" = ""
    "metadata_http_endpoint"               = "enabled"
    "metadata_http_tokens"                 = "required"
    "metadata_http_put_response_hop_limit" = 1
  },
  compute = {
    "vm_type" = "m5.xlarge"
    "cpu_type" = "AL2_x86_64"
    "os_disk_type" = "gp2"
    "os_disk_size" = 200
    "os_disk_iops" = 0
    "min_nodes" = 1
    "max_nodes" = 1
    "node_taints" = ["workload.sas.com/class=compute:NoSchedule"]
    "node_labels" = {
      "workload.sas.com/class"        = "compute"
      "launcher.sas.com/prepullImage" = "sas-programming-environment"
    }
    "custom_data" = ""
    "metadata_http_endpoint"               = "enabled"
    "metadata_http_tokens"                 = "required"
    "metadata_http_put_response_hop_limit" = 1
  },
  stateless = {
    "vm_type" = "m5.2xlarge"
    "cpu_type" = "AL2_x86_64"
    "os_disk_type" = "gp2"
    "os_disk_size" = 200
    "os_disk_iops" = 0
    "min_nodes" = 2
    "max_nodes" = 2
    "node_taints" = ["workload.sas.com/class=stateless:NoSchedule"]
    "node_labels" = {
      "workload.sas.com/class" = "stateless"
    }
    "custom_data" = ""
    "metadata_http_endpoint"               = "enabled"
    "metadata_http_tokens"                 = "required"
    "metadata_http_put_response_hop_limit" = 1
  },
  stateful = {
    "vm_type" = "m5.2xlarge"
    "cpu_type" = "AL2_x86_64"
    "os_disk_type" = "gp2"
    "os_disk_size" = 200
    "os_disk_iops" = 0
    "min_nodes" = 1
    "max_nodes" = 2
    "node_taints" = ["workload.sas.com/class=stateful:NoSchedule"]
    "node_labels" = {
      "workload.sas.com/class" = "stateful"
    }
    "custom_data" = ""
    "metadata_http_endpoint"               = "enabled"
    "metadata_http_tokens"                 = "required"
    "metadata_http_put_response_hop_limit" = 1
  }
}

# Jump Server
existingJumpServer                   = true
existingNFS                          = true
jumpserver_instanceid                = "i-06f441ea221a36e50"
nfs_instanceid                       = "i-0d8263e072d1c807c"
jump_vm_admin                         = "jumpuser"

# NFS Server
# required ONLY when storage_type is "standard" to create NFS Server VM
nfs_vm_admin                          = "nfsuser"
azs = [ "us-east-2a", "us-east-2b" ]
