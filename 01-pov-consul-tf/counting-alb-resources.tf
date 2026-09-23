
#############################################################
# Counting Load Balancer Target Group (Port 9000)
#############################################################
resource "aws_lb_target_group" "counting-instance-tg" {
  name        = "counting-instance-tg"
  port        = 9000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dashboard-vpc.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    port                = "9000"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "counting-instance-tg"
  }
}
# Attach Counting Instances to the Target Group
resource "aws_lb_target_group_attachment" "counting-instance1-attach" {
  target_group_arn = aws_lb_target_group.counting-instance-tg.arn
  target_id        = aws_instance.counting_instance1.id
  port             = 9000
}
resource "aws_lb_target_group_attachment" "counting-instance2-attach" {
  target_group_arn = aws_lb_target_group.counting-instance-tg.arn
  target_id        = aws_instance.counting_instance2.id
  port             = 9000
}
#############################################################
# Create ALB (counting-alb)
#############################################################
resource "aws_lb" "counting-alb" {
  name               = "counting-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.counting-alb-sg.id]
  subnets            = [
    aws_subnet.dashboard-private-subnet1.id,
    aws_subnet.dashboard-private-subnet2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "counting-alb"
  }
}
#############################################################
# Create Listener for Counting Load Balancer (Port 80)
#############################################################
resource "aws_lb_listener" "counting-alb-listener" {
  load_balancer_arn = aws_lb.counting-alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Directs traffic to the backend instances on port 9000 via your Target Group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.counting-instance-tg.arn
  }
}