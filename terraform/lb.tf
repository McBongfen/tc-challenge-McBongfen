resource "aws_lb_target_group" "my-lb" {
  name     = "application-my-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 10
    matcher = 200
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "attach-instance-0" {
  target_group_arn = aws_lb_target_group.my-lb.arn
  target_id        = aws_instance.instance[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach-instance-1" {
  target_group_arn = aws_lb_target_group.my-lb.arn
  target_id        = aws_instance.instance[1].id
  port             = 80
}


resource "aws_lb_listener" "my-lb_end" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-lb.arn
  }
}

resource "aws_lb" "my-lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.subnet[0].id,aws_subnet.subnet[1].id]

  enable_deletion_protection = false

  tags = {
    Environment = "my-lb"
  }
}
