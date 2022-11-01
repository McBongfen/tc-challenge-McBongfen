resource "aws_instance" "instance" {
  count = 2
  ami           = "ami-0d5bf08bc8017c83b"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet[count.index].id}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.dynamo-db_profile.name}"
  key_name = "mykey"
  user_data = <<-EOL
  #!/bin/bash -xe
  
  sudo apt update
  sudo apt install python3-flask -y
  sudo apt install python3-pip -y
  sudo apt install gunicorn -y
  export TC_DYNAMO_TABLE=Candidates
  EOL 


 tags ={
    Name= "${var.instance-tag[count.index]}"
  }
}

