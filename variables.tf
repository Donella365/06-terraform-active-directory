variable "yourname" {
  description = "Your name — used to make resource names unique."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "domain_name" {
  description = "Fully qualified domain name (e.g. corp.example.com)."
  type        = string
  default     = "corp.example.com"
}

variable "domain_netbios" {
  description = "NetBIOS name for the domain (max 15 characters)."
  type        = string
  default     = "CORP"
}

variable "rdp_source" {
  description = "Your public IP in CIDR format — e.g. 1.2.3.4/32. Find at whatismyip.com"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default = {
    project = "ad-lab"
  }
}