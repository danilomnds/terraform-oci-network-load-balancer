# ─── Network Load Balancer ────────────────────────────────────────────────────

variable "assigned_ipv6" {
  description = "IPv6 address to be assigned to the NLB. Must be part of one of the subnet prefixes. Example: '2607:9b80:9a0a:9a7e:abcd:ef01:2345:6789'."
  type        = string
  default     = null
}

variable "assigned_private_ipv4" {
  description = "Private IPv4 address to be assigned to the NLB. Must be within the subnet CIDR range. Example: '10.0.0.1'."
  type        = string
  default     = null
}

variable "compartment_id" {
  description = "The OCID of the compartment where the NLB will be created."
  type        = string
}

variable "defined_tags" {
  description = "Defined tags for the NLB resource. Each key is predefined and scoped to a namespace. If null, default tags from locals.tf are applied."
  type        = map(string)
  default     = null
}

variable "display_name" {
  description = "A user-friendly display name for the Network Load Balancer. Can be changed after creation."
  type        = string
}

variable "freeform_tags" {
  description = "Free-form tags for the NLB resource. Example: {\"Department\": \"Finance\"}."
  type        = map(string)
  default     = null
}

variable "is_preserve_source_destination" {
  description = "When enabled, skipSourceDestinationCheck is set on the NLB VNIC so packets reach backends with original source/destination IPs intact."
  type        = bool
  default     = false
}

variable "is_private" {
  description = "Whether the NLB has a VCN-local (private) IP address. If false, a public IP is assigned. Defaults to true."
  type        = bool
  default     = true
}

variable "is_symmetric_hash_enabled" {
  description = "Enables symmetric hash. Only applicable in transparent mode with is_preserve_source_destination enabled."
  type        = bool
  default     = false
}

variable "network_security_group_ids" {
  description = "List of Network Security Group OCIDs to associate with the NLB."
  type        = list(string)
  default     = []
}

variable "nlb_ip_version" {
  description = "IP version associated with the NLB. Allowed values: IPV4, IPV6, IPV4_AND_IPV6."
  type        = string
  default     = null
}

variable "reserved_ips" {
  description = "List of reserved IP OCIDs (Public IP, Private IP, or IPv6) to attach to the NLB at creation time. Reserved IPs are not deleted when the NLB is deleted."
  type        = list(string)
  default     = []
}

variable "security_attributes" {
  description = "ZPR security attributes for the NLB. Example: {\"oracle-zpr\" = {\"td\" = {\"value\" = \"42\", \"mode\" = \"audit\"}}}."
  type        = map(any)
  default     = null
}

variable "subnet_id" {
  description = "The OCID of the subnet where the NLB will be deployed."
  type        = string
}

variable "subnet_ipv6cidr" {
  description = "IPv6 subnet CIDR prefix for NLB IPv6 address assignment. Requires a dual-stack or IPv6-only NLB."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags merged with default_tags from locals.tf."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Optional custom timeout durations for create, update, and delete operations. Defaults are 20 minutes each."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}


variable "backend_sets" {
  description = "List of backend sets to create for the NLB. The 'name' attribute must be unique and becomes the backend set name."
  type = list(object({
    are_operationally_active_backends_preferred = optional(bool)    
    health_checker = object({
      dns = optional(object({
        domain_name        = string
        query_class        = optional(string)
        query_type         = optional(string)
        rcodes             = optional(list(string))
        transport_protocol = optional(string)
      }))
      interval_in_millis  = optional(number)
      port                = optional(number)
      protocol            = string
      request_data        = optional(string)
      response_body_regex = optional(string)
      response_data       = optional(string)
      retries             = optional(number)
      return_code         = optional(number)
      timeout_in_millis   = optional(number)
      url_path            = optional(string)
    })
    ip_version                            = optional(string)
    is_fail_open                          = optional(bool)
    is_instant_failover_enabled           = optional(bool)
    is_instant_failover_tcp_reset_enabled = optional(bool)
    is_preserve_source                    = optional(bool)
    name                                  = string
    policy                                = string
  }))
  default = []
}

variable "listeners" {
  description = "List of listeners to create for the NLB. The 'name' attribute must be unique and becomes the listener name."
  type = list(object({
    default_backend_set_name = string
    ip_version               = optional(string)
    is_ppv2enabled           = optional(bool)
    l3ip_idle_timeout        = optional(number)
    name                     = string
    port                     = number
    protocol                 = string
    tcp_idle_timeout         = optional(number)
    udp_idle_timeout         = optional(number)
  }))
  default = []
}

variable "backends" {
  description = "List of backends to create for the NLB. The 'name' attribute must be unique within each backend set."
  type = list(object({
    backend_set_name = string
    ip_address       = optional(string)
    is_backup        = optional(bool)
    is_drain         = optional(bool)
    is_offline       = optional(bool)
    name             = optional(string)
    port             = number
    target_id        = optional(string)
    weight           = optional(number)
  }))
  default = []
}

# ─── IAM / Policies ───────────────────────────────────────────────────────────

variable "compartment" {
  description = "The compartment name where the NLB is deployed. Used in IAM policy statements."
  type        = string
  default     = null
}

variable "groups" {
  description = "List of IAM groups that will receive access policies for this resource."
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "Set to true to create IAM policies for this resource."
  type        = bool
  default     = false
}

variable "tenancy_ocid" {
  description = "The OCID of the tenancy. Required when policies = true (policies are created in the root compartment)."
  type        = string
  default     = null
}