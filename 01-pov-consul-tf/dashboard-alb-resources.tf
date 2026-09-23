
#############################################################
# Dashboard Load Balancer Target Group (Port 8000)
#############################################################
resource "aws_lb_target_group" "dashboard-instance-tg" {
  name        = "dashboard-instance-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dashboard-vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    port                = "8000"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "dashboard-instance-tg"
  }
}
# Attach Dashboard Instances to the Target Group
resource "aws_lb_target_group_attachment" "dashboard-instance1-attach" {
  target_group_arn = aws_lb_target_group.dashboard-instance-tg.arn
  target_id        = aws_instance.dashboard_instance1.id
  port             = 8000
}
resource "aws_lb_target_group_attachment" "dashboard-instance2-attach" {
  target_group_arn = aws_lb_target_group.dashboard-instance-tg.arn
  target_id        = aws_instance.dashboard_instance2.id
  port             = 8000
}
#############################################################
# Create ALB (dashboard-alb)
#############################################################
resource "aws_lb" "dashboard-alb" {
  name               = "dashboard-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dashboard-alb-sg.id]
  subnets            = [
    aws_subnet.dashboard-public-subnet1.id,
    aws_subnet.dashboard-public-subnet2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "dashboard-alb"
  }
}
#############################################################
# Create Listener for Counting Load Balancer (Port 80)
#############################################################
resource "aws_lb_listener" "dashboard-alb-listener" {
  load_balancer_arn = aws_lb.dashboard-alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Directs traffic to the backend instances on port 9000 via your Target Group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard-instance-tg.arn
  }
}