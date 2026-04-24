# Type d'instance EC2 (modifiable facilement)
variable "instance_type" {
  description = "Type des instances EC2"
  type        = string
  default     = "t3.micro"
}