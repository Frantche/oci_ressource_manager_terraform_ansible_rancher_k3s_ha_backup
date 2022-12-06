variable "compartment_ocid" {
  type        = string
  description = "define oracle compartment_ocid"
}

variable "tenancy_ocid" {
  type        = string
  description = "define oracle tenancy_ocid"
}

variable "region" {
  type        = string
  description = "define oracle region"
}

variable "availability_domain" {
  type        = string
  description = "define oracle availability_domain in Datacenter to place Instance"
}

variable "tag_key" {
  default     = "project"
  type        = string
  description = "define oracle tag key for the project"
}

variable "tag_value" {
  default     = "k3s-terraform"
  type        = string
  description = "define oracle tag value for the project"
}

variable "oci_core_vcn_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "define oracle Virtual network CIDR"
}

variable "oci_core_subnet_public" {
  default     = "10.0.0.0/24"
  type        = string
  description = "define oracle CIDR for public subnet"
}

variable "oci_core_subnet_private" {
  default     = "10.0.1.0/24"
  type        = string
  description = "define oracle CIDR for private subnet"
}

variable "network_load_balancer_reserved_ips_id" {
  default     = null
  type        = string
  description = "It is the public IP that will be used by the loadbalancer. A DNS rules must be set to route traffic"
}

variable "autorized_key" {
  default     = ""
  type        = string
  description = "define SSH public key that will be allowed to connect to instance"
}

variable "ssh_username" {
  default     = "opc"
  type        = string
  description = "define username  will be allowed to connect to instance"
}

variable "k3s_version" {
  default     = "latest"
  type        = string
  description = "define k3s version"
}

variable "server_os_image_id" {
  type        = string
  description = "define oracle os_image_id, it must be an Oracle Linux image"
}

variable "server_shape_name" {
  default     = "VM.Standard.A1.Flex"
  type        = string
  description = "define the shape of server instance"
}

variable "server_shape_ocpu" {
  default     = 1
  type        = number
  description = "define the shape of server instance"
}

variable "server_shape_memory" {
  default     = 6
  type        = number
  description = "define the shape of server instance"
}

variable "server_pool_size" {
  default     = 3
  type        = number
  description = "define how many server instance will be deployed"
}

variable "agent_os_image_id" {
  type        = string
  description = "define oracle os_image_id, it must be an Oracle Linux image"
}
variable "agent_shape_name" {
  default     = "VM.Standard.A1.Flex"
  type        = string
  description = "define the shape of agent instance"
}

variable "agent_shape_ocpu" {
  default     = 1
  type        = number
  description = "define the shape of agent instance"
}

variable "agent_shape_memory" {
  default     = 6
  type        = number
  description = "define the shape of agent instance"
}

variable "agent_pool_size" {
  default     = 3
  type        = number
  description = "define how many agent instance will be deployed"
}

variable "bastion_bastion_type" {
  default     = "STANDARD"
  type        = string
  description = "Define the type of bastion"
}

variable "bastion_name" {
  default     = "k3sbastion"
  type        = string
  description = "define oracle bastion name"
}

variable "bastion_client_cidr_block_allow_list" {
  default = ["0.0.0.0/0"]
}

variable "k3s_token" {
  default     = "2aaf122eed3409ds2c6fagfad4073-92dcdgade664d8c1c7f49z"
  type        = string
  description = "define k3s cluster token"
}

variable "rancher_hostname" {
  default     = "rancher.example.com"
  type        = string
  description = "The DNS Name you choose to redirect trafic to rancher"
}

variable "email" {
  default     = "email@example.com"
  type        = string
  description = "The email that will be used to receive notification, set letsencrypt certificate"
}

variable "acme_server_name" {
  default     = "letsencrypt-prod"
  type        = string
  description = "Default ACME is letsencrypt production"
}

variable "acme_server_url" {
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  type        = string
  description = "ACME server url"
}

variable "rancher_is_first_install" {
  default     = true
  type        = bool
  description = "If you select first installation, the backup process will not be triggered"
}

variable "rancher_version" {
  default     = "v2.7.0"
  type        = string
  description = "The version of the rancher helm chart you want to install"
}

variable "rancher_backup_enable" {
  default     = true
  type        = bool
  description = "Do you want to activate rancher backup fonctionnality ?"
}

variable "rancher_backup_version" {
  default     = "v3.0.0"
  type        = string
  description = "The version of the rancher backup helm chart you want to install"
}

variable "rancher_backup_filename" {
  default     = ""
  type        = string
  description = "The name of the backup file you want to restore on your instance"
}

variable "rancher_backup_bucket_name" {
  default     = ""
  type        = string
  description = "The name of the S3 bucket"
}

variable "rancher_backup_folder" {
  default     = ""
  type        = string
  description = "Optional | Base folder within the bucket"
}

variable "rancher_backup_accessKey" {
  default     = ""
  type        = string
  description = "The accesskey to your S3 storage"
}

variable "rancher_backup_secretKey" {
  default     = ""
  type        = string
  description = "The secretkey to your S3 storage"
}
variable "rancher_backup_region" {
  default     = ""
  type        = string
  description = "The region of the S3 bucket. Depending of the S3 providor, this value can be empty"
}

variable "rancher_backup_endpoint" {
  default     = ""
  type        = string
  description = "Endpoint for the S3 storage provider"
}

variable "rancher_backup_endpointCA" {
  default     = ""
  type        = string
  description = "Optional | Base64 encoded CA cert for the S3 storage provider"
}

variable "rancher_backup_encryption_config_secretbox" {
  default     = ""
  type        = string
  description = "Optional | Secretbox encryption phrase that will be used to encrypt and decrypt rancher backup"
}

variable "rancher_backup_schedule" {
  default     = "@every 1h"
  type        = string
  description = "The frequency of backup. Default is every hour, custom must be define as a Cron expression"
}

variable "rancher_backup_retentioncount" {
  default     = "10"
  type        = string
  description = "The number of backup to be keep."
}
