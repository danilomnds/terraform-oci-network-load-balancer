resource "oci_network_load_balancer_network_load_balancer" "load_balancer" {
  assigned_ipv6         = var.assigned_ipv6
  assigned_private_ipv4 = var.assigned_private_ipv4
  compartment_id        = var.compartment_id
  defined_tags   = var.defined_tags != null ? var.defined_tags : local.tags
  display_name   = var.display_name
  #freeform_tags  = var.freeform_tags
  is_preserve_source_destination = var.is_preserve_source_destination
  is_private                     = var.is_private
  is_symmetric_hash_enabled      = var.is_symmetric_hash_enabled
  network_security_group_ids     = var.network_security_group_ids
  nlb_ip_version             = var.nlb_ip_version
  dynamic "reserved_ips" {
    for_each = var.reserved_ips != null ? var.reserved_ips : []
    content {
      id = reserved_ips.value
    }
  }
  security_attributes = var.security_attributes
  subnet_id           = var.subnet_id
  subnet_ipv6cidr     = var.subnet_ipv6cidr
  lifecycle {
    ignore_changes = [
      defined_tags["IT.create_date"]
    ]
  }
  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}

resource "oci_identity_policy" "lb_policy" {
  provider   = oci.home
  depends_on = [oci_network_load_balancer_network_load_balancer.load_balancer]
  for_each = {
    for group in var.groups : group => group
    if var.groups != [] && var.compartment != null && var.policies == true
  }
  compartment_id = var.tenancy_ocid
  name           = "policy_nlb_${lower(replace(each.value, "OracleIdentityCloudService/", ""))}"
  description    = "policy to allow groups to read network load balancers in compartment ${var.compartment}"
  statements = [
    "Allow group ${each.value} to read load-balancers in compartment ${var.compartment}"
  ]
}

resource "oci_network_load_balancer_backend_set" "backend_set" {
  depends_on = [ oci_network_load_balancer_network_load_balancer.load_balancer ]
  for_each = { for bs in var.backend_sets : bs.name => bs }
  network_load_balancer_id                    = oci_network_load_balancer_network_load_balancer.load_balancer.id
  are_operationally_active_backends_preferred = try(each.value.are_operationally_active_backends_preferred, null)  
  health_checker {
    dynamic "dns" {
      for_each = try(each.value.health_checker.dns, null) != null ? [each.value.health_checker.dns] : []
      content {
        domain_name        = dns.value.domain_name
        query_class        = try(dns.value.query_class, null)
        query_type         = try(dns.value.query_type, null)
        rcodes             = try(dns.value.rcodes, null)
        transport_protocol = try(dns.value.transport_protocol, null)
      }
    }
    interval_in_millis  = each.value.health_checker.interval_in_millis
    port                = each.value.health_checker.port
    protocol            = each.value.health_checker.protocol
    request_data        = try(each.value.health_checker.request_data, null)
    response_body_regex = try(each.value.health_checker.response_body_regex, null)
    response_data       = try(each.value.health_checker.response_data, null)
    retries             = each.value.health_checker.retries
    return_code         = try(each.value.health_checker.return_code, null)
    timeout_in_millis   = each.value.health_checker.timeout_in_millis
    url_path            = try(each.value.health_checker.url_path, null)
  }
  ip_version                                  = try(each.value.ip_version, null)
  is_fail_open                                = try(each.value.is_fail_open, null)
  is_instant_failover_enabled                 = try(each.value.is_instant_failover_enabled, null)
  is_instant_failover_tcp_reset_enabled       = try(each.value.is_instant_failover_tcp_reset_enabled, null)
  is_preserve_source                          = try(each.value.is_preserve_source, null)
  name                                        = each.value.name
  policy                                      = each.value.policy
}

resource "oci_network_load_balancer_listener" "listener" {
  depends_on = [ oci_network_load_balancer_backend_set.backend_set ]
  for_each = { for l in var.listeners : l.name => l }
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.load_balancer.id
  default_backend_set_name = each.value.default_backend_set_name
  ip_version               = try(each.value.ip_version, null)
  is_ppv2enabled           = try(each.value.is_ppv2enabled, null)
  l3ip_idle_timeout        = try(each.value.l3ip_idle_timeout, null)
  name                     = each.value.name
  port                     = each.value.port
  protocol                 = each.value.protocol
  tcp_idle_timeout         = try(each.value.tcp_idle_timeout, null)
  udp_idle_timeout         = try(each.value.udp_idle_timeout, null)
}

resource "oci_network_load_balancer_backend" "backend" {
  depends_on = [oci_network_load_balancer_backend_set.backend_set]
  for_each   = { for b in var.backends : "${coalesce(b.ip_address, b.target_id)}/${b.port}" => b }
  backend_set_name         = each.value.backend_set_name
  ip_address               = try(each.value.ip_address, null)
  is_backup                = try(each.value.is_backup, null)
  is_drain                 = try(each.value.is_drain, null)
  is_offline               = try(each.value.is_offline, null)
  name                     = try(each.value.name, null)
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.load_balancer.id
  port                     = each.value.port
  target_id                = try(each.value.target_id, null)
  weight                   = try(each.value.weight, null)
}