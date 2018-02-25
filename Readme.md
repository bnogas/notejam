
**Requirements:** \
pip3 install aws \
pip3 install ansible 

**Amazon configuration:** \
export AWS_ACCESS_KEY=\<project access key\> \
export AWS_SECRET_ACCESS_KEY=\<project secret access key\> \
export AWS_REGION=us-east-2 \
export AWS_ACCOUNT_ID=\<aws account id\>

**Change region:** \
To change region please adjust *ami_ecs_optimized* and  *elb_access_ids*

**Local dev:** \
cd vagrant; vagrant up; vagrant ssh \
make tests # to run tests \
make coverage # check code coverage \
make runserver # to start local dev django server
