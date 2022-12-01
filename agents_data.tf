data "oci_core_instance_pool_instances" "k3s_agents_instances" {
  depends_on = [
    oci_core_instance_pool.k3s_agents,
  ]
  compartment_id   = var.compartment_ocid
  instance_pool_id = oci_core_instance_pool.k3s_agents.id
}

data "oci_core_instance" "k3s_agents_instances_ips" {
  count       = var.agent_pool_size
  instance_id = data.oci_core_instance_pool_instances.k3s_agents_instances.instances[count.index].id
}