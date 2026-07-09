variable "availability_zones" {
  type = list(any)
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "intra_subnets" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}