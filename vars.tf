# Configure these variables

variable "course_prefix" {
  description = "A sample_var to pass to the template."
  default     = "hello"
}

variable "sleepy_time" {
  description = "How long our local-exec will take a nap."
  default     = 0
}

variable "vpc_name" {
  description = "Name of the vpc"
  type        = string
  default     = "tf-academy-training-vpc"
}

variable "image" {
  description = "Image ID for the instance"
  type        = string
  default     = "ibm-redhat-7-9-minimal-amd64-3"
}

variable "profile" {
  description = "Profile type for the Instance"
  type        = string
  default     = "bx2-2x8"
}