#!/usr/bin/python3.8
import urllib3 
import json
import os
from jinja2 import Template

http = urllib3.PoolManager() 

def lambda_handler(event, context): 
    
    to_slack(event, context)
    to_teams(event, context)

    
def to_slack(event, context):
    url = os.environ.get("SLACK_WEBHOOK")
    msg = {
        "text": event['Records'][0]['Sns']['Message']
    }
    encoded_msg = json.dumps(msg,indent=4).encode('utf-8')
    headers = {'content-type': 'application/json'}
    resp = http.request('POST',url, body=encoded_msg, headers=headers)
    print({
        "request_body": encoded_msg, 
        "status_code": resp.status, 
        "response": resp.data
    })
    
def to_teams(event, context):

    with open('teams_template.json', 'r') as file:
        template = file.read()

    try:
        alarm = json.loads(event['Records'][0]['Sns']['Message'])
    except:
        alarm = {}
    
    try:
        alarm['AWSRegionId'] = alarm.get('AlarmArn').split(':')[3]
    except:
        alarm['AWSRegionId'] = "eu-west-1"
    
    t = Template(template)
    encoded_msg = t.render(alarm)
    

    headers = {'content-type': 'application/json'}
    url = os.environ.get("TEAMS_WEBHOOK")
    resp = http.request('POST',url, body=encoded_msg, headers=headers)
    print({
        "request_body": encoded_msg, 
        "status_code": resp.status, 
        "response": resp.data
    })
    