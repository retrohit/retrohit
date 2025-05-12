resource "aws_eip" "jenkins_master_eip" {
  instance = aws_instance.jenkins_master.id
  domain   = "vpc"
}

resource "aws_eip" "jenkins_slave_eip" {
  instance = aws_instance.jenkins_slave.id
  domain   = "vpc"
}

resource "aws_eip" "sonarqube_server_eip" {
  instance = aws_instance.sonar_server.id
  domain   = "vpc"
}

resource "aws_eip" "nexus_server_eip" {
  instance = aws_instance.nexus_server.id
  domain   = "vpc"
}

resource "aws_eip" "new_k8s_server_eip" {
  instance = aws_instance.new_k8s_server.id
  domain   = "vpc"
}

