resource "oci_core_vcn" "default" {
  cidr_block     = var.oci_core_vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "Default OCI core vcn"
  dns_label      = "defaultvcn"
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}

resource "oci_core_subnet" "public" {
  cidr_block        = var.oci_core_subnet_public
  compartment_id    = var.compartment_ocid
  display_name      = "${var.oci_core_subnet_public} OCI core subnet public"
  dns_label         = "public"
  route_table_id    = oci_core_route_table.public.id
  vcn_id            = oci_core_vcn.default.id
  security_list_ids = [oci_core_default_security_list.default_security_list.id, oci_core_security_list.public.id]
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}

resource "oci_core_subnet" "private" {
  cidr_block                 = var.oci_core_subnet_private
  compartment_id             = var.compartment_ocid
  display_name               = "${var.oci_core_subnet_private} OCI core subnet private"
  dns_label                  = "private"
  route_table_id             = oci_core_route_table.private.id
  vcn_id                     = oci_core_vcn.default.id
  security_list_ids          = [oci_core_default_security_list.default_security_list.id, oci_core_security_list.bastion.id, oci_core_security_list.private.id]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true

  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}


resource "oci_core_internet_gateway" "default" {
  compartment_id = var.compartment_ocid
  display_name   = "Internet Gateway Default OCI core vcn"
  enabled        = "true"
  vcn_id         = oci_core_vcn.default.id
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}


resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  display_name = "Default route Public"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.default.id
  }
}


resource "oci_core_nat_gateway" "default" {
  #Required
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  #Optional
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  display_name = "Default route Private"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.default.id
  }
}