locals {
  default_tags = {
    "IT.deployedby" : "Terraform"
    "IT.provider" : "oci"
    "IT.create_date" : formatdate("DD/MM/YY hh:mm", timeadd(timestamp(), "-3h"))
  }
  tags = merge(local.default_tags, var.tags)
}
