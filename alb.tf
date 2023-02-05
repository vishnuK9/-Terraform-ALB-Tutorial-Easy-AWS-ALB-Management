resource "aws_lb_target_group" "my_app_eg1" {
  name     = "my_app_eg1"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }

  health_check {
    enabled = true
    port = 8081
    interval = 30
    protocol = "HTTP"
    path = "/health"
    matcher = "200"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "my_app_eg1" {
  for_each = aws_instance.my_app_eg1
  target_group_arn = aws_lb_target_group.my_app_eg1.arn
  target_id        = each.value.id
  port             = 8080
}

resource "aws_lb" "my_app_eg1" {
  name = "my-app-eg1"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_eg1.id]

  subnets = [
    aws_subnet.public_us_east_1a.id,
    aws_subnet.public_us_east_1b.id
  ]
}

resource "aws_lb_listener" "http_eg1" {
  load_balancer_arn = aws_lb.my_app_eg1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_eg1.arn
  }
}