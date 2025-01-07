# Declaring the AWS Provider
data "aws_route53_zone" "selected" {
  name         = "servarccarwash.com"
  private_zone = false
}
/*
resource "aws_route53_record" "domainName" {
  name    = "sonar"
  type    = "A"
  zone_id = data.aws_route53_zone.selected.zone_id
  records = [aws_instance.sonarqube.public_ip]
  ttl     = 300
  depends_on = [
    aws_instance.sonarqube
  ]
}
*/
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "servarccarwash.com"
  type    = "A"

  alias {
    name                   = aws_lb.class-demo-alb.dns_name
    zone_id                = aws_lb.class-demo-alb.zone_id
    evaluate_target_health = true
  }
}