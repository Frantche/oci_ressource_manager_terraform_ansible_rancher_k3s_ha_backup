resource "oci_core_network_security_group" "agent_security_group" {
  #Required
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id

  #Optional
  display_name = "agent security group"
  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }
}

resource "oci_core_network_security_group_security_rule" "agent_security_group_rule_http" {
  #Required
  network_security_group_id = oci_core_network_security_group.agent_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"

  #Optional
  description = "HTTP traffic"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  tcp_options {

    #Optional
    destination_port_range {
      #Required
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "agent_security_group_rule_https" {
  #Required
  network_security_group_id = oci_core_network_security_group.agent_security_group.id
  direction                 = "INGRESS"
  protocol                  = "6"

  #Optional
  description = "HTTP traffic"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  tcp_options {

    #Optional
    destination_port_range {
      #Required
      max = 443
      min = 443
    }
  }
}