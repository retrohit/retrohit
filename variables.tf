variable "instance_ami" {
  description = "AMI ID"
  type        = string
  default     = "ami-023a307f3d27ea427"  
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.medium"  
}

variable "key_name" {
  description = "SSH Key Pair Name"
  type        = string
  default     = "retrohit" 
}
