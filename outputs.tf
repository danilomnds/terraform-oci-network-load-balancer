output "id" {
  description = "The OCID of the Network Load Balancer."
  value       = oci_network_load_balancer_network_load_balancer.load_balancer.id
}

output "display_name" {
  description = "The display name of the Network Load Balancer."
  value       = oci_network_load_balancer_network_load_balancer.load_balancer.display_name
}

output "ip_addresses" {
  description = "The list of IP address objects assigned to the Network Load Balancer."
  value       = oci_network_load_balancer_network_load_balancer.load_balancer.ip_addresses
}

output "state" {
  description = "The current lifecycle state of the Network Load Balancer."
  value       = oci_network_load_balancer_network_load_balancer.load_balancer.state
}

output "backend_sets" {
  description = "The backend sets created for the Network Load Balancer."
  value       = oci_network_load_balancer_backend_set.backend_set
}

output "listeners" {
  description = "The listeners created for the Network Load Balancer."
  value       = oci_network_load_balancer_listener.listener
}

output "backends" {
  description = "The backends created for the Network Load Balancer."
  value       = oci_network_load_balancer_backend.backend
}