variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "instance_count" {
  type    = number
  default = 2
  validation {
    condition     = var.instance_count >= 2
    error_message = "Au moins deux instances sont requises."
  }
}

variable "dns_name" {
  type    = string
  default = "adem-cloud.example"
}
