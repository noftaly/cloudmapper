#!/bin/bash
yum install -y python3-devel.x86_64 git
# All these libs are needed to build a python package ("pyjq") to parse json
yum install -y gcc autoconf make automake libtool
git clone https://username:token@gitlab.com/aws-cni/cloudmapper.git /root/cloudmapper
cd /root/cloudmapper/
pip3 install -r requirements.txt
mkdir ~/.aws
cat > ~/.aws/credentials << EOF
[415927316367_CloudMapper]
aws_access_key_id=
aws_secret_access_key=
aws_session_token=
EOF
cp ./config.json.demo ./config.json
make collecteu account=demo profile=415927316367_CloudMapper
make prepare account=demo
python3 cloudmapper.py webserver --public
