resource "aws_instance" "jenkins_master" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.retrohit_subnet.id
  vpc_security_group_ids      = [aws_security_group.retrohit_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "retrohit-jenkins-master"
  }
}

resource "aws_instance" "jenkins_slave" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.retrohit_subnet.id
  vpc_security_group_ids      = [aws_security_group.retrohit_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "retrohit-jenkins-slave"
  }
}

resource "aws_instance" "sonar_server" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.retrohit_subnet.id
  vpc_security_group_ids      = [aws_security_group.retrohit_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "retrohit-sonarqube-server"
  }
}

resource "aws_instance" "nexus_server" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.retrohit_subnet.id
  vpc_security_group_ids      = [aws_security_group.retrohit_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "retrohit-nexus-server"
  }
}

# New Kubernetes server
resource "aws_instance" "new_k8s_server" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.retrohit_subnet.id
  vpc_security_group_ids      = [aws_security_group.retrohit_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "retrohit-new-k8s-server"
  }
}

resource "aws_instance" "k8s_worker" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.retrohit_subnet.id
  vpc_security_group_ids      = [aws_security_group.retrohit_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "retrohit-k8s-worker"
  }
}
