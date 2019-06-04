# ----- provider && profile -----

provider "aws" {
  version = "1.13.0"
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
} 

# ----- instance -----

resource "aws_key_pair" "jenkins_auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "jenkins_dev" {
  instance_type = "${var.instance_type}"
  ami = "${var.instance_ami}"

  tags {
    Name = "jenkins_dev"
  }


  key_name = "${aws_key_pair.jenkins_auth.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_dev_sg.id}"]
  subnet_id = "${aws_subnet.jenkins_public1_subnet.id}"


   provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.jenkins_dev.id} --profile jenkins && hostname"
  }


}
# ----- VPC -----

resource "aws_vpc" "jenkins_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true 

  tags {
    Name = "jenkins_vpc"
  }
}

# give our ENV a route to the internet

resource "aws_internet_gateway" "jenkins_internet_gateway" {
  vpc_id = "${aws_vpc.jenkins_vpc.id}"

  tags {
    Name = "jenkins_igw"
  }
}

# Route tables

resource "aws_route_table" "jenkins_public_rt" {
  vpc_id = "${aws_vpc.jenkins_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jenkins_internet_gateway.id}"
  }

  tags {
    Name = "jenkins_public"
  }
}

resource "aws_default_route_table" "jenkins_private_rt" {
  default_route_table_id = "${aws_vpc.jenkins_vpc.default_route_table_id}"

  tags {
    Name = "jenkins_public"
  }
}

# Subnets

resource "aws_subnet" "jenkins_public1_subnet" {
  vpc_id = "${aws_vpc.jenkins_vpc.id}"
  cidr_block = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "jenkins_public1"
  }
}

# Subnet Associations

resource "aws_route_table_association" "jenkins_pulic1_assoc" {
  subnet_id = "${aws_subnet.jenkins_public1_subnet.id}"
  route_table_id = "${aws_route_table.jenkins_public_rt.id}"
}


# security groups

resource "aws_security_group" "jenkins_dev_sg" {
  name = "jenkins_dev_sg"
  description = "Used for access to the DEV instance"
  vpc_id = "${aws_vpc.jenkins_vpc.id}"

  # ssh rule

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.localip}"]
  }

  # http rule

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    # use this to lock down from outside world
    cidr_blocks = ["${var.localip}"]
    # use this to allow access from www
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Public Security Group

resource "aws_security_group" "jenkins_public_sg" {
  name = "jenkins_public_sg"
  description = "Used for the elastic load balancer for public access" 
  vpc_id = "${aws_vpc.jenkins_vpc.id}"

  # http rule 

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
