data "oci_core_vnic_attachments" "k3s_server_vnic_attachments" {
  #Required
  count          = var.server_pool_size
  compartment_id = var.compartment_ocid
  #first server
  instance_id = data.oci_core_instance_pool_instances.k3s_servers_instances.instances[count.index].id
}


resource "oci_core_private_ip" "server_floating_ip" {

  #Optional
  display_name = "Server floatingIP"
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}",
    "k3s-cluster"    = "server"
  }
  vnic_id = data.oci_core_vnic_attachments.k3s_server_vnic_attachments[0].vnic_attachments[0].vnic_id
}