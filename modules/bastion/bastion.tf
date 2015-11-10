#
# Docker bastion autoscale group configurations
#
resource "aws_autoscaling_group" "bastion" {
  name = "bastion"
  availability_zones = [ "${var.bastion_subnet_az_a}", "${var.bastion_subnet_az_b}", "${var.bastion_subnet_az_c}"]
  min_size = "${var.cluster_min_size}"
  max_size = "${var.cluster_max_size}"
  desired_capacity = "${var.cluster_desired_capacity}"
  
  health_check_type = "EC2"
  force_delete = true
  
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  vpc_zone_identifier = ["${var.bastion_subnet_a_id}","${var.bastion_subnet_b_id}","${var.bastion_subnet_c_id}"]
  
  tag {
    key = "Name"
    value = "bastion"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "bastion" {
  # use system generated name to allow changes of launch_configuration
  # name = "workder-${var.ami}"
  image_id = "${var.ami}"
  instance_type = "${var.image_type}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"
  security_groups = [ "${aws_security_group.bastion.id}" ]
  key_name = "${var.keypair}"
  lifecycle { create_before_destroy = true }

  # /root
  root_block_device = {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size}" 
  }
  # /var/lib/docker
  ebs_block_device = {
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = "${var.docker_volume_size}" 
  }

  user_data = "${file("cloud-config/s3-cloudconfig-bootstrap.sh")}"
}

resource "aws_iam_instance_profile" "bastion" {
    name = "bastion"
    roles = ["${aws_iam_role.bastion.name}"]
}

resource "aws_iam_role_policy" "bastion_policy" {
    name = "bastion"
    role = "${aws_iam_role.bastion.id}"
    policy = "${file(\"policies/bastion_policy.json\")}"
}

resource "aws_iam_role" "bastion" {
    name = "bastion"
    path = "/"
    assume_role_policy =  "${file(\"policies/assume_role_policy.json\")}"
}