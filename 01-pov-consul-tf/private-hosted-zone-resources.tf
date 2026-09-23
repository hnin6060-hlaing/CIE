resource "aws_route53_zone" "cloudio" {
  name = "cloud.io"

  # Associating a vpc block turns the hosted zone private
  vpc {
    vpc_id = aws_vpc.dashboard-vpc.id
  }

  tags = {
    Environment = "dev"
  }
}
resource "aws_route53_record" "dashboard-cloudio" {
  zone_id = aws_route53_zone.cloudio.zone_id
  name    = "dashboard.cloud.io"
  type    = "A"
  alias {
    name                   = aws_lb.dashboard-alb.dns_name
    zone_id                = aws_lb.dashboard-alb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "counting-cloudio" {
  zone_id = aws_route53_zone.cloudio.zone_id
  name    = "counting.cloud.io"
  type    = "A"
  alias {
    name                   = aws_lb.counting-alb.dns_name
    zone_id                = aws_lb.counting-alb.zone_id
    evaluate_target_health = true
  }
}