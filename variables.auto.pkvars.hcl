instance_type   = "t2.micro"
region          = "us-east-1"
profile         = "dev"
ami_filter_name = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
device_type     = "ebs"
virtual_type    = "hvm"
ami_name        = "amazon-linux-2-node-mysql-ami"
ssh_username    = "ec2-user"
ssh_timeout     = "2h"
ami_user        = "285317072413"
owner           = "amazon"
NODE_ENV        = "dev"
DB_USERNAME     = "root"
DB_PASSWORD     = "Leomessi@1!"
DB_DIALECT      = "mysql"
PORT            = 5000
DB              = "usersdb"
DB_HOST         = "127.0.0.1"