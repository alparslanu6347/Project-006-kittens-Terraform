variable "domain" {
  default     = "kittens.devopsalparslanugurer.com"
  type        = string
  description = "The domain name for the website."
}


variable "bucket-name" {
  default     = "kittens.devopsalparslanugurer.com"
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}
