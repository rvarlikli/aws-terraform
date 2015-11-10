bastion: etcd plan_bastion upload_bastion_userdata
	cd $(BUILD); \
		$(SCRIPTS)/aws-keypair.sh -c bastion; \
		$(TF_APPLY) -target module.bastion
	@$(MAKE) bastion_ips

plan_bastion: plan_etcd init_bastion 
	cd $(BUILD); \
		$(TF_PLAN) -target module.bastion;

refresh_bastion: | $(TF_PORVIDER)
	cd $(BUILD); \
		$(TF_REFRESH) -target module.bastion
	@$(MAKE) bastion_ips

destroy_bastion: | $(TF_PORVIDER)
	cd $(BUILD); \
	  $(SCRIPTS)/aws-keypair.sh -d bastion; \
		$(TF_DESTROY) -target module.bastion.aws_autoscaling_group.bastion; \
		$(TF_DESTROY) -target module.bastion.aws_launch_configuration.bastion; \
		$(TF_DESTROY) -target module.bastion 

clean_bastion: destroy_bastion
	rm -f $(BUILD)/module-bastion.tf

init_bastion: init
	cp -rf $(RESOURCES)/terraforms/module-bastion.tf $(BUILD)
	cd $(BUILD); $(TF_GET);

bastion_ips:
	@echo "bastion public ips: " `$(SCRIPTS)/get-ec2-public-id.sh bastion`

upload_bastion_userdata: init_build_dir
	cd $(BUILD); \
		$(SCRIPTS)/gen-userdata.sh bastion $(CONFIG)/cloudinit-bastion.def

.PHONY: bastion destroy_bastion refresh_bastion plan_bastion init_bastion clean_bastion upload_bastion_userdata bastion_ips
