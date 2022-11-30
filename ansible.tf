# ------ Create SSH Config File
resource "tls_private_key" "public_private_key_pair" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "private_key_file" {
  filename = abspath("${path.module}/key.pem")
  content  = tls_private_key.public_private_key_pair.private_key_openssh
}

resource "local_file" "ansible_config" {
  filename = abspath("${path.module}/ansible.cfg")
  content  = file("template/ansible.tpl")
}

resource "local_file" "ssh_config_file" {
  content = templatefile("template/ssh-config.tpl",
    {
      master_private_ip       = data.oci_core_instance.k3s_servers_instances_ips.*.private_ip
      agent_private_ip        = data.oci_core_instance.k3s_agents_instances_ips.*.private_ip
      private_key_path        = local_sensitive_file.private_key_file.filename
      destination_ssh_user    = var.ssh_username
      bastion_username        = oci_bastion_session.k3s_access_bastion_session.id
      bastion_hostname        = "host.bastion.${var.region}.oci.oraclecloud.com"
      first_master_private_ip = data.oci_core_instance.k3s_servers_instances_ips.0.private_ip
    }
  )
  filename = abspath("${path.module}/ssh-config")
}

# ------ Setup Ansible Inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("template/inventory.tpl",
    {
      masters = data.oci_core_instance.k3s_servers_instances_ips.*.private_ip,
      agents  = data.oci_core_instance.k3s_agents_instances_ips.*.private_ip,
    }
  )
  filename = abspath("${path.module}/inventory/hosts.yaml")
}


# ------ Create Bastion Session

resource "oci_bastion_session" "k3s_access_bastion_session" {
  bastion_id = oci_bastion_bastion.k3s_access_bastion.id
  key_details {
    public_key_content = tls_private_key.public_private_key_pair.public_key_openssh
  }
  target_resource_details {
    session_type         = "PORT_FORWARDING"
    target_resource_id   = data.oci_core_instance.k3s_servers_instances_ips.0.id
    target_resource_port = 22

  }
  display_name           = "ansible-session"
  session_ttl_in_seconds = 3600
  depends_on             = [data.oci_core_instance.k3s_servers_instances_ips]
}

data "oci_bastion_session" "k3s_session" {
  session_id = oci_bastion_session.k3s_access_bastion_session.id
}

# ------ Execute Ansible
resource "null_resource" "use_ansible" {

  triggers = {
    build_number = "${timestamp()}"
  }

  depends_on = [
    oci_core_instance_pool.k3s_agents,
    oci_core_instance_pool.k3s_server,
    oci_bastion_session.k3s_access_bastion_session,
    oci_identity_policy.k3s_server,
    local_file.ansible_group_vars_all,
    local_file.ansible_group_vars_haproxy,
    local_file.ansible_group_vars_keepalived,
    local_file.ansible_host_vars_keepalived,
  ]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = var.ssh_username
      host                = data.oci_core_instance.k3s_servers_instances_ips.0.private_ip
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = "host.bastion.${var.region}.oci.oraclecloud.com"
      bastion_user        = oci_bastion_session.k3s_access_bastion_session.id
      bastion_port        = 22
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
      timeout             = "2m"
    }
    inline = [
      "touch ~/IMadeAFile.Right.Here"
    ]
  }

  provisioner "local-exec" {
    command = "chmod 400 ${local_sensitive_file.private_key_file.filename}"
  }
  provisioner "local-exec" {
    command = " ansible-galaxy install -r ./collections/requirements.yml; ansible-playbook --ssh-common-args '-F ${local_file.ssh_config_file.filename}' ./install_ansible_playbook.yml"
  }
}
