#!/usr/bin/env bash

region=$1

for instance in $(aws --profile dixonaws@amazon.com --region $region ec2 describe-instances |grep -i instanceid |awk -F ":" '{print $2}');
    do echo $instance

done

