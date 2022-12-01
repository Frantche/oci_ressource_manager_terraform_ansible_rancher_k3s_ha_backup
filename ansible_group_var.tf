resource "local_file" "ansible_group_vars_all" {
  content = templatefile("template/groups_vars.all.tpl",
    {
      k3s_version                                = var.k3s_version,
      ssh_username                               = var.ssh_username,
      loadbalancer_master_ip                     = oci_core_private_ip.server_floating_ip.ip_address,
      k3s_token                                  = var.k3s_token,
      rancher_version                            = var.rancher_version,
      rancher_backup_version                     = var.rancher_backup_version,
      rancher_hostname                           = var.rancher_hostname,
      email                                      = var.email,
      acme_server_url                            = var.acme_server_url,
      rancher_backup_filename                    = var.rancher_backup_filename,
      rancher_backup_accessKey                   = var.rancher_backup_accessKey,
      rancher_backup_secretKey                   = var.rancher_backup_secretKey,
      rancher_backup_bucket_name                 = var.rancher_backup_bucket_name,
      rancher_backup_region                      = var.rancher_backup_region,
      rancher_backup_folder                      = var.rancher_backup_folder,
      rancher_backup_endpoint                    = var.rancher_backup_endpoint,
      rancher_backup_endpointCA                  = var.rancher_backup_endpointCA,
      rancher_backup_encryption_config_secretbox = var.rancher_backup_encryption_config_secretbox,
      rancher_backup_schedule                    = var.rancher_backup_schedule,
      rancher_backup_retentioncount              = var.rancher_backup_retentioncount
    }
  )
  filename = abspath("${path.module}/inventory/group_vars/all.yml")
}

resource "local_file" "ansible_group_vars_haproxy" {
  content = templatefile("template/groups_vars.master.haproxy.tpl",
    {
      masters = data.oci_core_instance.k3s_servers_instances_ips.*.private_ip
    }
  )
  filename = abspath("${path.module}/inventory/group_vars/master/haproxy.yml")
}

resource "local_file" "ansible_group_vars_keepalived" {
  content = templatefile("template/groups_vars.master.keepalived.tpl",
    {
      loadbalancer_master_ip = oci_core_private_ip.server_floating_ip.ip_address
    }
  )
  filename = abspath("${path.module}/inventory/group_vars/master/keepalived.yml")
}