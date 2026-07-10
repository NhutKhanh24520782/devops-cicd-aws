variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "cluster_name" {
  type = string
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

variable "workstation_ip" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "bastion_ami" {
  type = string
}

variable "key_name" {
  type = string
}