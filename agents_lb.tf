resource "oci_network_load_balancer_network_load_balancer" "agent_k3s_load_balancer" {
  depends_on = [
    oci_core_instance_pool.k3s_agents,
  ]

  compartment_id = var.compartment_ocid
  display_name   = "k3s agent load balancer"
  subnet_id      = oci_core_subnet.public.id

  is_preserve_source_destination = false
  is_private                     = false

  freeform_tags = {
    "${var.tag_key}" = "${var.tag_value}"
  }

  reserved_ips {

    #Optional
    id = var.network_load_balancer_reserved_ips_id
  }
}

resource "oci_network_load_balancer_listener" "k3s_http_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  name                     = "k3s_http_listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.agent_k3s_load_balancer.id
  port                     = 80
  protocol                 = "TCP_AND_UDP"
}

resource "oci_network_load_balancer_backend_set" "k3s_http_backend_set" {
  health_checker {
    protocol    = "HTTP"
    port        = 80
    return_code = 404
    url_path    = "/"
  }

  name                     = "k3s_http_backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.agent_k3s_load_balancer.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = true
}



resource "oci_network_load_balancer_backend" "k3s_http_backend" {
  depends_on = [
    oci_core_instance_pool.k3s_agents,
  ]

  count                    = var.agent_pool_size
  backend_set_name         = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.agent_k3s_load_balancer.id
  port                     = 80

  target_id = data.oci_core_instance_pool_instances.k3s_agents_instances.instances[count.index].id

  name = "${data.oci_core_instance_pool_instances.k3s_agents_instances.instances[count.index].id}_80"
}



resource "oci_network_load_balancer_listener" "k3s_https_listener" {
  depends_on = [
    oci_core_instance_pool.k3s_agents,
    oci_network_load_balancer_listener.k3s_http_listener,
    oci_network_load_balancer_backend.k3s_http_backend,
    oci_network_load_balancer_backend_set.k3s_http_backend_set,
  ]

  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  name                     = "k3s_https_listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.agent_k3s_load_balancer.id
  port                     = 443
  protocol                 = "TCP_AND_UDP"
}

resource "oci_network_load_balancer_backend" "k3s_https_backend" {
  depends_on = [
    oci_core_instance_pool.k3s_agents,
    oci_network_load_balancer_listener.k3s_http_listener,
    oci_network_load_balancer_backend.k3s_http_backend,
    oci_network_load_balancer_backend_set.k3s_http_backend_set,
  ]

  count                    = var.agent_pool_size
  backend_set_name         = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.agent_k3s_load_balancer.id
  port                     = 443

  target_id = data.oci_core_instance_pool_instances.k3s_agents_instances.instances[count.index].id
  name      = "${data.oci_core_instance_pool_instances.k3s_agents_instances.instances[count.index].id}_443"
}

resource "oci_network_load_balancer_backend_set" "k3s_https_backend_set" {
  depends_on = [
    oci_core_instance_pool.k3s_agents,
    oci_network_load_balancer_listener.k3s_http_listener,
    oci_network_load_balancer_backend.k3s_http_backend,
    oci_network_load_balancer_backend_set.k3s_http_backend_set,
  ]

  health_checker {
    protocol    = "HTTPS"
    port        = 443
    return_code = 404
    url_path    = "/"

  }

  name                     = "k3s_https_backend"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.agent_k3s_load_balancer.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = true
}