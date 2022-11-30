resource "local_file" "ansible_host_vars_keepalived" {
  count = var.server_pool_size
  content = templatefile("template/host_vars.master.keepalived.tpl",
    {
      vnic_id = data.oci_core_vnic_attachments.k3s_server_vnic_attachments[count.index].vnic_attachments[0].vnic_id,
      count   = var.server_pool_size,
      index   = count.index
    }
  )
  filename = abspath("${path.module}/inventory/host_vars/${data.oci_core_instance.k3s_servers_instances_ips[count.index].private_ip}/keepalived.yml")
}