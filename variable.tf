variable "domain" {
  default     = "kittens.devopsarrow.com"   // write your domain (devopsarrow.com)
  type        = string
  description = "The domain name for the website."
}


variable "bucket-name" {
  default     = "kittens.devopsarrow.com"   // write your static website bucket-name
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}
