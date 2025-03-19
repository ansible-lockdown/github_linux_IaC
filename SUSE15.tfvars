# Ami opensuse15.6
# owner id 679593333241
# https://rockylinux.org/download - cloud images - aws - us-east1
# aws ec2 describe-images --owner 679593333241  --filters "Name=name,Values=openSUSE*Leap*v20250131*" "Name=architecture,Values=x86_64"
ami_id        = "ami-0dfb672f1aaf629a7"
ami_os        = "suse15"
ami_username  = "ec2-user"
ami_user_home = "/home/ec2-user"
benchmark_os  = "SUSE15"
