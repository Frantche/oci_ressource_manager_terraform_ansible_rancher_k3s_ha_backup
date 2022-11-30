resource "oci_core_instance_pool" "k3s_agents" {

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, freeform_tags]
  }

  display_name              = "k3s-agents"
  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.k3s_agent_template.id

  placement_configurations {
    availability_domain = var.availability_domain
    primary_subnet_id   = oci_core_subnet.private.id
  }

  size  = var.agent_pool_size
  state = "RUNNING"
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}",
    "k3s-cluster"    = "agent"
  }
}