resource "oci_bastion_bastion" "k3s_access_bastion" {
  #Required
  bastion_type     = var.bastion_bastion_type
  compartment_id   = var.compartment_ocid
  target_subnet_id = oci_core_subnet.public.id

  #Optional
  client_cidr_block_allow_list = split(",", var.bastion_client_cidr_block_allow_list)

  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
  name = var.bastion_name
}
