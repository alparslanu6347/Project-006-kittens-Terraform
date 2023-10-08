variable "domain" {
  default     = "kittens.devopsarrow.com"   // write your domain
  type        = string
  description = "The domain name for the website."
}


variable "bucket-name" {
  default     = "kittens.devopsarrow.com"   // write your bucket-name
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}
