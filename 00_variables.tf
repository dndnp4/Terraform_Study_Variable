
#######################
# Common
#######################
variable "region" {
  type = string
}

variable "az" {
  type = list(string)
}

variable "name_prefix" {
  type = string
}

variable "common_ssh_key" {
  type = object({ name = string, path = string })
}

#######################
# Networks (CIDR range) 
#######################
variable "cidr_all" {
  type = string
}

variable "cidr_vpc" {
  type = string
}

variable "cidr_public_subnets" {
  type = list(string)
}

variable "cidr_private_subnets" {
  type = list(string)
}

variable "cidr_private_db_subnets" {
  type = list(string)
}

#######################
# EC2
#######################
variable "ec2_webserver_options" {
  type = object(
    {
      ami               = string,
      instance_type     = string,
      user_data_path    = string,
      sample_private_ip = string
    }
  )
}
