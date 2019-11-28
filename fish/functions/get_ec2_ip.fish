function get_ec2_ip
	aws ec2 describe-instances --output table   --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, PublicIpAddress]'  --filters "Name=tag-value,Values=*$argv*" "Name=instance-state-name, Values=running"
end
