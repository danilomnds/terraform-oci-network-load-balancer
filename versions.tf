terraform {
  # specify the required Terraform version. Best practice is to set this to the latest version of Terraform that supports all the features used in this module
  required_version = ">= 1.14.8"
  required_providers {
    oci = {
      source  = "oracle/oci"
      # update to the latest version of the provider that supports all the features used in this module
      version = ">= 8.8.0"
      # home region is required for some resources such as policies and dynamic groups
      configuration_aliases = [oci.home]
    }
  }
}