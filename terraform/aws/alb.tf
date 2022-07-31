resource "aws_alb_target_group" "main" {
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default.id
  target_type = "ip"

  health_check {
    path = "/"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "main" {
  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = aws_alb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
}

resource "aws_alb" "main" {
  security_groups    = [aws_security_group.alb.id]
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
}
