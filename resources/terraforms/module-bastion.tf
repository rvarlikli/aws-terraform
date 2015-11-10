module "bastion" {
    source = "../modules/bastion"

    image_type = "t2.micro"
    cluster_desired_capacity = 1
    root_volume_size =  8
    docker_volume_size =  12
    keypair = "bastion"
    allow_ssh_cidr="0.0.0.0/0"

    # aws
    aws_account_id="${var.aws_account.id}"
    aws_region = "${var.aws_account.default_region}"
    ami = "${var.ami}"

    # vpc
    vpc_id = "${module.vpc.vpc_id}"
    vpc_cidr = "${module.vpc.vpc_cidr}"
    bastion_subnet_a_id = "${module.vpc.bastion_subnet_a_id}"
    bastion_subnet_b_id = "${module.vpc.bastion_subnet_b_id}"
    bastion_subnet_c_id = "${module.vpc.bastion_subnet_c_id}"
    bastion_subnet_az_a = "${module.vpc.bastion_subnet_az_a}"
    bastion_subnet_az_b = "${module.vpc.bastion_subnet_az_b}"
    bastion_subnet_az_c = "${module.vpc.bastion_subnet_az_c}"
}