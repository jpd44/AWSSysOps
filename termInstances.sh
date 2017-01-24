#!/bin/bash

function termInstance() {
	instance=$(echo $1 |awk -F "," '{print $1}')
	trimmedInstanceString=$(sed -e 's/^"//' -e 's/"$//' <<<"$instance")
	region=$2

	echo -n "Terminating instance $trimmedInstanceString... "
	aws --profile dixonaws@amazon.com --region $region ec2 terminate-instances --instance-ids $trimmedInstanceString

	echo "done."
}

function changeTermProtection() {
	# echo the first parameter passed
	instance=$(echo $1 |awk -F "," '{print $1}')
	trimmedInstanceString=$(sed -e 's/^"//' -e 's/"$//' <<<"$instance")
	region=$2
	echo -n "Modifying $trimmedInstanceString... "

	# change termination protection on $instance
	aws --profile dixonaws@amazon.com --region $region ec2 modify-instance-attribute --instance-id $trimmedInstanceString --attribute=disableApiTermination --value false

	echo "done"
}

region=sa-east-1
for instance in $(aws --profile dixonaws@amazon.com --region $region ec2 describe-instances |grep -i instanceid |awk -F ":" '{print $2}'); do changeTermProtection $instance $region; termInstance $instance $region; done




