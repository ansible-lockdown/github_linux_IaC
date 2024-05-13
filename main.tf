provider "aws" {
  profile = ""
  region  = var.aws_region
}

// instance setup

resource "aws_instance" "testing_vm" {
  ami                         = var.ami_id
  availability_zone           = var.availability_zone
  key_name                    = var.ami_key_pair_name  # This is the key as known in the ec2 key_pairs
  instance_type               = var.instance_type
  subnet_id                   = "subnet-03ee2c5bbc174ce8f"
  vpc_security_group_ids      = ["sg-06e2d8c9ec31196e4"]
  tags = {
    Environment = "${var.environment}"
    Name        = "${var.benchmark_os}-${var.benchmark_type}"
  }
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
  root_block_device {
    delete_on_termination = true
    tags = {
      Environment = "${var.environment}"
      Name        = "${var.benchmark_os}-${var.benchmark_type}-rootvol"
    }
  }
}

// generate inventory file
resource "local_file" "inventory" {
  filename             = "./hosts.yml"
  directory_permission = "0755"
  file_permission      = "0644"
  content              = <<EOF
    # benchmark host
    all:
      hosts:
        ${var.ami_os}:
          ansible_host: ${aws_instance.testing_vm.private_ip}
          ansible_user: ${var.ami_username}
      vars:
        setup_audit: true
        run_audit: true
        system_is_ec2: true
        skip_reboot: false
        amzn2023cis_rule_1_2_2: false  # Breaks patching
        amzn2023cis_rule_1_2_4: false  # Breaks patching
        amzn2023cis_rule_4_6_6: false  # default image has no root password and nopasswd not removed from sudo
        rhel_07_010340: false
        rhel7stig_bootloader_password_hash: 'grub.pbkdf2.sha512.somethingnewhere'  # pragma: allowlist secret
        rhel9cis_rule_5_6_6: false  # skip root passwd check and keys only
        rhel9stig_audit_log_filesystem: '/'
        # passwd strings
        grub_user_pass: 'grub.pbkdf2.sha512.10000.D268F2334B417C788C859A1104D489BE73205AFB74539DCAB0AC3F4A3B2ADE34D994D6D86A6F665200608F88050BCBC5D161ED07DE78C39D3C2BAE345F22DCEE.730C7E0F06BBDD2A54FF7BE93B710E94E1B1B61FE8E0BF27313E2429AF2C57348BF2EA647E39EF5AB13BE3EF3B1972FA5082EEB62AB9436314EA851D8042F423'  # pragma: allowlist secret
        grub_user_passwd: '$y$j9T$MBA5l/tQyWifM869nQjsi.$cTy0ConcNjIYOn6Cppo5NAky20osrkRxz4fEWA8xac6'
        root_passwd: '$6$m1u7QuCBzmdHhig3$Ss48R6udPO.sISy8XphR2jlLhGqQiLoKkjdqVVU7zsU108oOq25.Bj0BTeafnljaur7iMnQPYXpRCzgXc6o4U1'  # pragma: allowlist secret
        ### Debian
        debian11cis_bootloader_password_hash: "{{ grub_user_pass }}"
        debian11cis_set_grub_user_pass: true
        debian11cis_grub_user_passwd: "{{ grub_user_passwd }}"
        debian11cis_root_pw: "{{ root_passwd }}"
        debian11cis_purge_apt: true
        debian11cis_allow_common_auth_rewrite: true
        ## Passwds for ubuntu
        ubtu20cis_bootloader_password_hash: "{{ grub_user_pass }}"
        ubtu20cis_root_pw: "{{ root_passwd }}"
        ubtu22cis_rule_5_3_4: false  # Excluded as default AWS build has no password for user
        ubtu22cis_bootloader_password_hash: "{{ grub_user_pass }}"
        ubtu22cis_set_grub_user_pass: true
        ubtu22cis_grub_user_passwd: "{{ grub_user_passwd }}"
    EOF
}
