# 1. Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = "Project2-VPC" }
}

# 2. Create Two Subnets
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "Subnet-A" }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "Subnet-B" }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# 4. Routing
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt.id
}

# 5. Security Group
resource "aws_security_group" "alb_sg" {
  name   = "alb-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  # 6. Launch Template (The blueprint for new servers)
resource "aws_launch_template" "web_config" {
  name_prefix   = "web-config"
  image_id      = "ami-0c101f26f147fa7fd" 
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.alb_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Project 2 Server</h1>" > /var/www/html/index.html
              EOF
  )
}

# 7. Auto Scaling Group (The "Manager")
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2

  launch_template {
    id      = aws_launch_template.web_config.id
    version = "$Latest"
  }
  
  # Links the ASG to the Target Group so servers are added to the Load Balancer
  target_group_arns = [aws_lb_target_group.main_tg.arn]
}

# 8. Target Group (The "Waiting Room" for servers)
resource "aws_lb_target_group" "main_tg" {
  name     = "project2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# 9. Load Balancer (The "Receptionist")
resource "aws_lb" "main_alb" {
  name               = "project2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

# 10. Listener (The "Ear" that listens for web traffic)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_tg.arn
  }
}