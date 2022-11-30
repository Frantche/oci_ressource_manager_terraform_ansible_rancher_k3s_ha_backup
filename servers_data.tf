
data "oci_core_instance_pool_instances" "k3s_servers_instances" {

  compartment_id   = var.compartment_ocid
  instance_pool_id = oci_core_instance_pool.k3s_server.id
}

data "oci_core_instance" "k3s_servers_instances_ips" {
  count       = var.server_pool_size
  instance_id = data.oci_core_instance_pool_instances.k3s_servers_instances.instances[count.index].id
}