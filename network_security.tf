resource "oci_core_default_security_list" "default_security_list" {
  compartment_id             = var.compartment_ocid
  manage_default_resource_id = oci_core_vcn.default.default_security_list_id

  display_name = "Default security list"
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  display_name = "allow traffic public vcn"

  ingress_security_rules {
    protocol = 6 # tcp
    source   = "0.0.0.0/0"

    description = "Allow HTTP from all"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = "0.0.0.0/0"

    description = "Allow HTTPS from all"

    tcp_options {
      min = 443
      max = 443
    }
  }

  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}

resource "oci_core_security_list" "bastion" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  display_name = "allow traffic from bastion"

  ingress_security_rules {
    protocol = 6 # tcp
    source   = var.oci_core_subnet_public

    description = "Allow for bastion"

    tcp_options {
      min = 22
      max = 22
    }
  }

  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}

resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  display_name = "Allow k3s traffic inside vcn private"

  ingress_security_rules {
    protocol = "all"
    source   = var.oci_core_subnet_private

    description = "All traffic"
  }
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}