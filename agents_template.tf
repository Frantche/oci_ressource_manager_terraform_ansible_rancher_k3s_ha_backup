resource "oci_core_instance_configuration" "k3s_agent_template" {

  compartment_id = var.compartment_ocid
  display_name   = "Oracle Linux 8 instance k3s agent configuration"

  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }

  instance_details {
    instance_type = "compute"

    launch_details {

      agent_config {
        is_management_disabled = "false"
        is_monitoring_disabled = "false"

        plugins_config {
          desired_state = "ENABLED"
          name          = "Vulnerability Scanning"
        }

        plugins_config {
          desired_state = "ENABLED"
          name          = "Compute Instance Monitoring"
        }

        plugins_config {
          desired_state = "ENABLED"
          name          = "Bastion"
        }
      }

      availability_domain = var.availability_domain
      compartment_id      = var.compartment_ocid

      create_vnic_details {
        assign_public_ip = false
        subnet_id        = oci_core_subnet.private.id
        nsg_ids          = [oci_core_network_security_group.agent_security_group.id]
      }

      display_name = "Oracle Linux k3s agent template"

      metadata = {
        "ssh_authorized_keys" = join("\n", [var.autorized_key, tls_private_key.public_private_key_pair.public_key_openssh])
      }

      shape = var.agent_shape_name

      dynamic "shape_config" {
        for_each = local.is_agent_flex_shape
        content {
          memory_in_gbs = var.agent_shape_memory
          ocpus         = var.agent_shape_ocpu
        }
      }

      source_details {
        image_id    = var.agent_os_image_id
        source_type = "image"
      }
    }
  }
}