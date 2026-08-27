resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  variavel_inexistente = var.variavel_inexistente

  # Exige IMDSv2, evitando roubo de credenciais da instance role via SSRF
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "HelloWorld"
  }
}