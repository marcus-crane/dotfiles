#!/usr/bin/env python3
import os
import sys

import boto3
from base64 import b64encode
from terminaltables import AsciiTable

cluster = os.environ.get('ECS_CLUSTER_ARN')
if not cluster:
    sys.exit("The ECS_CLUSTER_ARN variable is missing from your environment.")

client = boto3.client('ecs')
ec2_client = boto3.client('ec2')

tasks = client.list_tasks(cluster=cluster)
if not tasks:
    sys.exit("Hmm, there were no tasks found on that cluster")

arn_list = tasks.get('taskArns')

task_descs = client.describe_tasks(cluster=cluster, tasks=arn_list).get('tasks')
services = list()

for task in task_descs:
    services.append({
        "name": task['group'].replace('service:', ''),
        "task_def_version": task['taskDefinitionArn'].split(':')[-1],
        "container": task['containerInstanceArn']
    })

container_list = dict()
for service in services:
    container_list[service['container']] = ''

container_instances = client.describe_container_instances(cluster=cluster, containerInstances=list(container_list.keys())).get('containerInstances')
for container in container_instances:
    containerArn = container.get('containerInstanceArn')
    for service in services:
        if containerArn == service['container']:
            service['ec2_instance'] = container.get('ec2InstanceId')

ec2_ids = [container.get('ec2InstanceId') for container in container_instances]
ec2_instances = ec2_client.describe_instances(InstanceIds=ec2_ids)['Reservations']

for item in ec2_instances:
    inst_id = item['Instances'][0]['InstanceId']
    address = item['Instances'][0]['PrivateIpAddress']
    for service in services:
        if inst_id == service['ec2_instance']:
            service['address'] = address

services = sorted(services, key=lambda k: k['address'])

table_data = [
    ["Task", "Version", "IP Address"]
]

for entry in services:
    table_data.append([
        entry['name'],
        entry['task_def_version'],
        entry['address']
    ])

table = AsciiTable(table_data)

print(table.table)
