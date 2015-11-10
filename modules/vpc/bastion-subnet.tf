# subnet for bastion cluster

variable "bastion_subnet_a" { default = "10.0.50.0/24" }
variable "bastion_subnet_b" { default = "10.0.51.0/24" }
variable "bastion_subnet_c" { default = "10.0.52.0/24" }
variable "bastion_subnet_az_a" { default = "us-west-2a" }
variable "bastion_subnet_az_b" { default = "us-west-2b" }
variable "bastion_subnet_az_c" { default = "us-west-2c" }

resource "aws_subnet" "bastion_a" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.bastion_subnet_az_a}"
    cidr_block = "${var.bastion_subnet_a}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "bastion_a"
    }
}

resource "aws_route_table_association" "bastion_rt_a" {
    subnet_id = "${aws_subnet.bastion_a.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

resource "aws_subnet" "bastion_b" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.bastion_subnet_az_b}"
    cidr_block = "${var.bastion_subnet_b}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "bastion_b"
    }
}

resource "aws_route_table_association" "bastion_rt_b" {
    subnet_id = "${aws_subnet.bastion_b.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

resource "aws_subnet" "bastion_c" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.bastion_subnet_az_c}"
    cidr_block = "${var.bastion_subnet_c}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "bastion_c"
    }
}

resource "aws_route_table_association" "bastion_rt_c" {
    subnet_id = "${aws_subnet.bastion_c.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

output "bastion_subnet_a_id" { value = "${aws_subnet.bastion_a.id}" }
output "bastion_subnet_b_id" { value = "${aws_subnet.bastion_b.id}" }
output "bastion_subnet_c_id" { value = "${aws_subnet.bastion_c.id}" }
output "bastion_subnet_az_a" { value = "${var.bastion_subnet_az_a}" }
output "bastion_subnet_az_b" { value = "${var.bastion_subnet_az_b}" }
output "bastion_subnet_az_c" { value = "${var.bastion_subnet_az_c}" }