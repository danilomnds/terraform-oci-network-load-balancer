# Module - OCI Network Load Balancer
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![OCI](https://img.shields.io/badge/provider-OCI-red)](https://registry.terraform.io/providers/oracle/oci/latest)

Module developed to standardize the creation of OCI Network Load Balancers. Backend sets, backends, and listeners are each managed as separate resources (`oci_network_load_balancer_backend_set`, `oci_network_load_balancer_backend`, and `oci_network_load_balancer_listener`).

---

## Compatibility Matrix

| Module Version | Terraform Version | OCI Provider Version |
|----------------|-------------------|----------------------|
| v1.0.0         | 1.14.8            | 8.8.0                |

---

## Use case

```hcl
module "oci_network_load_balancer" {
  source = "git::https://github.com/danilomnds/terraform-oci-network-load-balancer.git?ref=v1.0.0"
  providers = {
    oci      = oci
    oci.home = oci.home
  }

  # Required
  compartment_id = var.compartment_id
  display_name   = "my-nlb"
  subnet_id      = var.subnet_id

  # Backend sets
  backend_sets = [
    {
      name   = "my-backend-set"
      policy = "FIVE_TUPLE"
      health_checker = {
        port     = 80
        protocol = "TCP"
      }
    }
  ]

  # Backends
  backends = [
    {
      backend_set_name = "my-backend-set"
      ip_address       = "10.0.0.10"
      name             = "backend-01"
      port             = 80
    }
  ]

  # Listeners
  listeners = [
    {
      name                     = "my-listener"
      default_backend_set_name = "my-backend-set"
      port                     = 80
      protocol                 = "TCP"
    }
  ]

  # Optional: IAM policies
  compartment  = "my-compartment"
  groups       = ["OracleIdentityCloudService/my-group"]
  policies     = true
  tenancy_ocid = var.tenancy_ocid
}
output "id" {
  value = module.oci_network_load_balancer.id
}
output "display_name" {
  value = module.oci_network_load_balancer.display_name
}
output "ip_addresses" {
  value = module.oci_network_load_balancer.ip_addresses
}
output "state" {
  value = module.oci_network_load_balancer.state
}
output "backend_sets" {
  value = module.oci_network_load_balancer.backend_sets
}
output "backends" {
  value = module.oci_network_load_balancer.backends
}
output "listeners" {
  value = module.oci_network_load_balancer.listeners
}
```

---

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| assigned_ipv6 | IPv6 address to assign to the NLB | `string` | `null` | no |
| assigned_private_ipv4 | Private IPv4 address to assign to the NLB | `string` | `null` | no |
| backend_sets | List of backend sets. Each object requires `name` (unique), `policy` and `health_checker` | `list(object)` | `[]` | no |
| backends | List of backends. Each object requires `backend_set_name`, `name` (unique within the backend set) and `port` | `list(object)` | `[]` | no |
| compartment_id | OCID of the compartment where the NLB will be created | `string` | — | yes |
| defined_tags | Defined tags. If null, default tags from locals.tf are applied | `map(string)` | `null` | no |
| display_name | User-friendly display name for the NLB | `string` | — | yes |
| freeform_tags | Free-form tags for the NLB | `map(string)` | `null` | no |
| is_preserve_source_destination | Enable source/destination preservation on the NLB VNIC | `bool` | `false` | no |
| is_private | Whether the NLB has a private IP. Defaults to true | `bool` | `true` | no |
| is_symmetric_hash_enabled | Enable symmetric hash (transparent mode only) | `bool` | `false` | no |
| listeners | List of listeners. Each object requires `name` (unique), `default_backend_set_name`, `port` and `protocol` | `list(object)` | `[]` | no |
| network_security_group_ids | NSG OCIDs to associate with the NLB | `list(string)` | `[]` | no |
| nlb_ip_version | IP version. Allowed: IPV4, IPV6, IPV4_AND_IPV6 | `string` | `null` | no |
| reserved_ips | Reserved IP OCIDs to attach at creation time | `list(string)` | `[]` | no |
| security_attributes | ZPR security attributes | `map(any)` | `null` | no |
| subnet_id | OCID of the subnet where the NLB will be deployed | `string` | — | yes |
| subnet_ipv6cidr | IPv6 CIDR prefix for NLB IPv6 address assignment | `string` | `null` | no |
| tags | Additional tags merged with default_tags | `map(string)` | `{}` | no |
| timeouts | Custom timeout durations for create/update/delete | `object` | `null` | no |
| compartment | Compartment name used in IAM policy statements | `string` | `null` | no |
| groups | IAM groups that will receive access policies | `list(string)` | `[]` | no |
| policies | Set to true to create IAM policies for this resource | `bool` | `false` | no |
| tenancy_ocid | Tenancy OCID. Required when policies = true | `string` | `null` | no |

---

## Output variables

| Name | Description |
|------|-------------|
| id | OCID of the Network Load Balancer |
| display_name | Display name of the Network Load Balancer |
| ip_addresses | List of IP address objects assigned to the NLB |
| state | Current lifecycle state of the NLB |
| backend_sets | Map of `oci_network_load_balancer_backend_set` resources created for the NLB |
| backends | Map of `oci_network_load_balancer_backend` resources created for the NLB |
| listeners | Map of `oci_network_load_balancer_listener` resources created for the NLB |

---

## Documentation

- [oci_network_load_balancer_network_load_balancer](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_network_load_balancer)
- [oci_network_load_balancer_backend_set](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_backend_set)
- [oci_network_load_balancer_backend](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_backend)
- [oci_network_load_balancer_listener](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_listener)

---

## Compatibility Matrix

| Module Version | Terraform Version | OCI Provider Version |
|----------------|-------------------|----------------------|
| v1.0.0         | >= 1.1.0          | >= 4.0.0             |

---

## Use case

```hcl
module "network_load_balancer" {
  source                  = "git::https://[GIT_SERVER]/[PROJECT]/[REPO]?ref=vX.X.X"
  compartment_id          = "<compartment_ocid>"
  display_name            = "my-nlb"
  subnet_id               = "<subnet_ocid>"
  is_private              = true
  listener_name           = "my-listener"
  backend_set_name        = "my-backend-set"
  backend_ip_address      = "10.0.0.10"
}
```

---

## Input variables

| Name                              | Description                                                                                 | Type           | Default   | Required |
|----------------------------------- |--------------------------------------------------------------------------------------------|----------------|-----------|:--------:|
| compartment_id                     | The OCID of the compartment where the NLB will be created.                                 | `string`       | n/a       | `Yes`      |
| display_name                       | The display name for the Network Load Balancer.                                            | `string`       | n/a       | `Yes`      |
| subnet_id                          | The OCID of the subnet where the NLB will be deployed.                                     | `string`       | n/a       | `Yes`      |
| is_private                         | Whether the Network Load Balancer is private.                                              | `bool`         | `true`    | No       |
| tags                               | A map of tags to assign to the resources.                                                  | `map(string)`  | `{}`      | No       |
| listener_name                      | The name of the listener.                                                                  | `string`       | n/a       | `Yes`      |
| listener_port                      | The port of the listener.                                                                  | `number`       | `80`      | No       |
| listener_protocol                  | The protocol of the listener.                                                              | `string`       | `"TCP"`   | No       |
| backend_set_name                   | The name of the backend set.                                                               | `string`       | n/a       | `Yes`      |
| backend_set_protocol               | The protocol of the backend set.                                                           | `string`       | `"TCP"`   | No       |
| backend_set_port                   | The port of the backend set.                                                               | `number`       | `80`      | No       |
| health_checker_protocol            | The protocol for the health checker.                                                       | `string`       | `"TCP"`   | No       |
| health_checker_port                | The port for the health checker.                                                           | `number`       | `80`      | No       |
| health_checker_interval_in_millis  | The interval between health checks in milliseconds.                                        | `number`       | `10000`   | No       |
| health_checker_retries             | The number of retries for the health checker.                                              | `number`       | `3`       | No       |
| health_checker_timeout_in_millis   | The timeout for the health checker in milliseconds.                                        | `number`       | `3000`    | No       |
| is_preserve_source_destination     | Whether to preserve the source and destination IPs.                                        | `bool`         | `false`   | No       |
| backend_ip_address                 | The IP address of a backend server to add to the NLB backend set.                          | `string`       | n/a       | `Yes`      |
| backend_port                       | The port of the backend server.                                                            | `number`       | `80`      | No       |
| backend_is_drain                   | Whether the backend is drained.                                                            | `bool`         | `false`   | No       |
| backend_is_backup                  | Whether the backend is a backup.                                                           | `bool`         | `false`   | No       |
| backend_is_offline                 | Whether the backend is offline.                                                            | `bool`         | `false`   | No       |
| backend_weight                     | The weight of the backend.                                                                 | `number`       | `1`       | No       |

---

## Output variables

| Name         | Description                                  |
|--------------|----------------------------------------------|
| nlb_ip_address | The IP address of the Network Load Balancer. |
| nlb_ocid     | The OCID of the Network Load Balancer.       |

---

## Documentation

[https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_network_load_balancer](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_network_load_balancer)