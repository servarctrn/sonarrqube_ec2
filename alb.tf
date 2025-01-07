# Terraform AWS Application Load Balancer (ALB)
resource "aws_lb" "class-demo-alb" {
  name               = "Class-Demo-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.class-demo-sg.id]
  subnets            = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]

# enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

# Terraform AWS Target Group Attached to the (ALB)
resource "aws_lb_target_group" "alb_tg" {
  name     = "class-demo-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
  health_check {
    path     = "/health"
    port     = "80"
    protocol = "HTTP"
  }
}

# Terraform AWS Target Group Attachments 
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.sonarqube-01.id
  port             = 80
  depends_on = [
    aws_lb_target_group.alb_tg,
    aws_instance.sonarqube-01,
  ]
}

resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
# target_id        = aws_lb.class-demo-alb.id
  target_id        = aws_instance.sonarqube-02.id
  port             = 80
  depends_on = [
    aws_lb_target_group.alb_tg,
    aws_instance.sonarqube-02,
  ]
}


# Terraform AWS ALB listers
resource "aws_lb_listener" "listener_elb" {
  load_balancer_arn = aws_lb.class-demo-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}