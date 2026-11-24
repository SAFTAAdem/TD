variable "project_id" {
  type    = string
  default = "polytech-dijon"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "instance_count" {
  type    = number
  default = 2
  validation {
    condition     = var.instance_count >= 2
    error_message = "Au moins deux VM sont requises."
  }
}

variable "dns_name" {
  type    = string
  default = "adem-cloud.example."
}
