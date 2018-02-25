import boto3
import json
import requests
import os

url = "http://169.254.170.2" + os.environ['AWS_CONTAINER_CREDENTIALS_RELATIVE_URI']
resp = requests.get(url=url)
data = json.loads(resp.text)
bucket_name = data['RoleArn'].split('/')[-1]

client = boto3.client(
    's3',
    aws_access_key_id=data['AccessKeyId'],
    aws_secret_access_key=data['SecretAccessKey'],
    aws_session_token=data['Token']
)

client.download_file(bucket_name, 'secret_env.sh', 'secret_env.sh')
client.download_file(bucket_name, 'db_config.sh', 'db_config.sh')
