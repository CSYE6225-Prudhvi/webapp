locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "amazon-linux-2" {
  ami_name      = "${var.ami_name}-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  profile       = var.profile
  tags = {
    Name = "${var.ami_name}-${local.timestamp}"
  }
  source_ami_filter {
    filters = {
      name                = var.ami_filter_name
      root-device-type    = var.device_type
      virtualization-type = var.virtual_type
    }
    most_recent = true
    owners      = [var.owner]
  }
  ami_users = [var.ami_user]

  ssh_username = var.ssh_username
  ssh_timeout  = var.ssh_timeout

  associate_public_ip_address = true
}

build {
  sources = ["source.amazon-ebs.amazon-linux-2"]

  provisioner "file" {
    source      = "./webapp.zip"
    destination = "webapp.zip"
  }

  provisioner "shell" {
    script = "install-s.sh"
  }

  provisioner "file" {
    source      = "config.json"
    destination = "/tmp/config.json"
  }

  provisioner "shell" {
    inline = [
      "sudo yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm"
    ]
  }
}
