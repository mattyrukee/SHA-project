packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "os_type" {
  type    = string
  default = "ubuntu"
}
source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-example-ubuntu-{{timestamp}}"
  instance_type = "t2.micro"
  region        = var.aws_region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    "Name"        = "Af-xtern-A"
    "Environment" = "development"
    "OS_Version"  = var.os_type == "Ubuntu 20.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}
build {
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    inline = [
      "if [ \"${var.os_type}\" = \"ubuntu\" ]; then",
      "  sudo apt-get update -y",
      "  sudo apt-get upgrade -y",
      "else",
      "  sudo yum update -y",
      "  sudo yum upgrade -y",
      "fi"
    ]
  }
}


#now we arwe good