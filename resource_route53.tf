data "aws_route53_zone" "hosted-zone" {
  name         = "devopsarrow.com."   // write your hosted-zone (devopsarrow.com.)
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.hosted-zone.id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.kittens-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.kittens-distribution.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_cloudfront_distribution.kittens-distribution]
}


output "domain_name" {
  value = var.domain
}
