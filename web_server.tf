# wordpress security group
resource "aws_security_group" "sg_webserver" {
  depends_on = [
    aws_vpc.vpc,
  ]

  name        = "sg webserver"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow TCP"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_bastion_host.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# wordpress ec2 instance
resource "aws_instance" "wordpress" {
  depends_on = [
    aws_security_group.sg_webserver,
    aws_instance.mysql
  ]
  ami = "ami-0c2b8ca1dad447f8a"
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_webserver.id]
  subnet_id = aws_subnet.public_subnet.id
  user_data = <<EOF
            #! /bin/bash
            yum update
            yum install docker git -y
            systemctl restart docker
            systemctl enable docker
            git clone https://github.com/juhik93/my-flask-app.git
            cd my-flask-app
            docker build -t flask-app:latest .
            docker run -d -p 5000:5000 flask-app
  EOF

  tags = {
      Name = "webserver"
  }
}
