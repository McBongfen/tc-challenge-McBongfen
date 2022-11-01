resource "aws_security_group" "jenkins-sg" {
  name        = "allow_http_access"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from my ip range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "jenkins-sg"
  }
}


resource "aws_instance" "jenkins" {
  count = 1
  ami           = "ami-0d5bf08bc8017c83b"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet[0].id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"]
  key_name = "mykey"
  user_data = <<-EOL
  #!/bin/bash -xe

  sudo apt update
  sudo apt install openjdk-11-jre -y
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update
  sudo apt-get install jenkins -y
  
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg lsb-release -y
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update  
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
  sudo usermod -aG docker $USER

  EOL

 tags ={
    Name= "jenkins-server"
  }
}

