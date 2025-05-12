output "jenkins_master_public_ip" {
  value = aws_eip.jenkins_master_eip.public_ip
}

output "jenkins_slave_public_ip" {
  value = aws_eip.jenkins_slave_eip.public_ip
}

output "sonarqube_server_public_ip" {
  value = aws_eip.sonarqube_server_eip.public_ip
}

output "nexus_server_public_ip" {
  value = aws_eip.nexus_server_eip.public_ip
}

output "new_k8s_server_public_ip" {
  value = aws_eip.new_k8s_server_eip.public_ip
}

output "k8s_worker_public_ip" {
  value = aws_instance.k8s_worker.public_ip
}

