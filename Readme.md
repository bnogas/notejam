## Local dev
There is local development configuration for vagrant.
```
cd vagrant
vagrant up
vagrant ssh
make tests # to run tests
make coverage # check code coverage
make runserver # to start local dev django server
```

## Provisioning
### Requirements:
```
pip3 install awscli --upgrade --user
pip3 install ansible  --upgrade --user
```

### Amazon AWS configuration:
For all the following scripts to work correctly you should set environmental
variables:
```
export AWS_ACCESS_KEY=<project access key>
export AWS_SECRET_ACCESS_KEY=<project secret access key>
export AWS_REGION=<aws_region>
export AWS_ACCOUNT_ID=<aws account id>
```

### Provisioning scripts configuration
```yaml
# Application name - it should be different across the environments
app_name: "notejam-prod"
# AWS region that you want to deploy in
aws_region: "{{ lookup('env', 'AWS_REGION') }}"
# vpc CIDR for a given region 
vpc_net: 172.24.0.0/16
# at least two subnets with different Availability zones:
subnets: [
    {cidr: 172.24.0.0/24, region: us-east-2, az: us-east-2a},
    {cidr: 172.24.1.0/24, region: us-east-2, az: us-east-2b}] 
# database backup retention
backup_retention: 7
# type of ec2 instance to provision
instance_type: t2.micro
# ECS container memory reservation in MB
container_memory: 400
# Select ECS optimized AMI for a region that you deploy in
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
ami_ecs_optimized: ami-b86a5ddd
# Your AWS account ID
aws_account_id: "{{ lookup('env', 'AWS_ACCOUNT_ID') }}"
# Select ELB access ids for logs in your load balancer. Look:
# https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
elb_access_ids: ["033677994240"]
# Script to generate random passsword
pwd_alias: "{{ lookup('password', '/dev/null length=15 chars=ascii_letters') }}"
# Number of ECS container instances
size: 2
# EC2 private key destination
key_dest: "~/.ssh/notejam-private.pem"
# Load balancer check interval
lb_check_interval: 30
```

### Run provisioning
    cd provision_scripts
    sh create_environment.sh
### Change region:
To change region please adjust *ami_ecs_optimized* and  *elb_access_ids*

## Runtime
Load balancer logs are stored in s3 bucket named ```<app_name>-logs``` \
Web tier logs are stored in CloudWatch in ```<app_name>``` stream. \
There are ```<app_name>``` dashboards in CloudWatch.

### Runtime scripts
**scale_nodes.sh**
```
./scale_nodes.sh <ENV> <NUM>
ENV - staging or prod
NUM - number of nodes to scale to
ex. ./scale_nodes.sh staging 0 # STOP staging environment
ex. ./scale_nodes.sh prod 3 # SCALE prod environment to 3 instances
```

**db_snapshot.sh**
```
./db_snapshot.sh <OP> <ENV> <SNAPSHOT>
Create/list or delete db snapshots
OP - list|create|delete
ENV - staging or prod
SNAPSHOT - snapshot name
ex. ./db_snapshot.sh list prod
ex. ./db_snapshot.sh create prod snapshot_name
```
**restore_db_snapshot.sh**
```
./restore_db_snapshot.sh <SNAPSHOT_NAME> <NEW_DB_INSTANCE_NAME>
```

### Runtime configuration
Runtime configuration is available in s3 bucket `<app_name>-ps`. \
There are two configuration files:
##### db_config.sh
```
export DB_PASSWORD=<PASS>
export DB_NAME=<DATABASE_NAME>
export DB_USER=<DATABASE_USERNAME>
export DB_HOST=<DATABASE MASTER NODE ADDRESS"

```

##### secret_env.sh
```
export INIT_ADMIN_PASSWORD=<INITIAL_DJANGO_PASSWORD>
# Optional parametrs
export GUNICORN_WORKERS=<NUMBER OF GUNICORN WORKERS> # DEFAULT 4
export GUNICORN_LOGLEVEL=<log level for gunicorn> # DEFAULT 'info'
```

### Initial django user
Initial django user name is `admin@internal.int`, the initial password is taken
from secret_env.sh file