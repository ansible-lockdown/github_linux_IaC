# Ami RHEL10
# https://rockylinux.org/download - cloud images - aws - us-east1
# Retrieved for rhel via aws ec2 describe-images --owners 309956199498 --query 'sort_by(Images, &Name)[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=RHEL-10*" --region us-east-1 --output table
# RHEL AMI
#ami_id        = "ami-03a13a09a711d3871"
# Alma AMI
ami_id        = "ami-07c611d7996eed811"
# Rocky Linux
#ami_id        = "ami-0612fe215a271aefb"
ami_os        = "rhel10"
ami_username  = "ec2-user"
ami_user_home = "/home/ec2-user"
instance_type = "t3.medium"
benchmark_os  = "RHEL10"
