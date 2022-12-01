resource "oci_identity_dynamic_group" "k3s_server" {
  #Required
  compartment_id = var.tenancy_ocid
  description    = "Allow K3s master to control Master Floating IP"
  matching_rule  = "any { instance.id='${join("', instance.id='", data.oci_core_instance.k3s_servers_instances_ips.*.id)~}' }"
  name           = "k3s_master"

  #Optional
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}",
    "k3s-cluster"    = "server"
  }
}

data "oci_identity_compartment" "current" {
  #Required
  id = var.compartment_ocid
}

resource "oci_identity_policy" "k3s_server" {
  #Required
  compartment_id = var.compartment_ocid
  description    = "Allow K3s master to control Master Floating IP"
  name           = "k3s_master_floating"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.k3s_server.name} to manage all-resources in compartment ${data.oci_identity_compartment.current.name}"
  ]
}