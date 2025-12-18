variable "vpc_cidr" {
  description = "The IP range for our network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "The size of our servers"
  type        = string
  default     = "t2.micro"
}