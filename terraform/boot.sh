#!/bin/bash

yum install -y python3-devel.x86_64 git awscli jq

# All these libs are needed to build a python package ("pyjq") to parse json
yum install -y gcc autoconf make automake libtool

git clone https://${gitlab_auth}@gitlab.com/aws-cni/cloudmapper.git /root/cloudmapper
cd /root/cloudmapper/
pip3 install -r requirements.txt

export AWS_ACCESS_KEY_ID=${cpk_tf_bot_access_key_id}
export AWS_SECRET_ACCESS_KEY=${cpk_tf_bot_secret_access_key}
mkdir ~/.aws
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id=$${AWS_ACCESS_KEY_ID}
aws_secret_access_key=$${AWS_SECRET_ACCESS_KEY}

EOF

txt=/tmp/assume-role-output.txt
aws sts assume-role --role-arn "${target_role_arn}" --role-session-name "Terraform" --output json > $txt
export AWS_SECRET_ACCESS_KEY=$(cat $txt | jq -c '.Credentials.SecretAccessKey' | tr -d '"' | tr -d ' ')
export     AWS_ACCESS_KEY_ID=$(cat $txt | jq -c '.Credentials.AccessKeyId'     | tr -d '"' | tr -d ' ')
export     AWS_SESSION_TOKEN=$(cat $txt | jq -c '.Credentials.SessionToken'    | tr -d '"' | tr -d ' ')

cat << EOF >> ~/.aws/credentials
[CloudMapper]
aws_access_key_id=$${AWS_ACCESS_KEY_ID}
aws_secret_access_key=$${AWS_SECRET_ACCESS_KEY}
aws_session_token=$${AWS_SESSION_TOKEN}

EOF

cp ./config.json.demo ./config.json
make collecteu account=demo profile=CloudMapper
make prepare account=demo
python3 cloudmapper.py webserver --public
