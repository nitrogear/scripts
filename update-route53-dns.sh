#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Load configuration from /root/.aws/credentials
AWS_ACCESS_KEY_ID=$(grep -i AWS_ACCESS_KEY_ID /root/.aws/credentials|awk '{print $3}')
AWS_SECRET_ACCESS_KEY=$(grep -i AWS_SECRET_ACCESS_KEY /root/.aws/credentials|awk '{print $3}')

# Export access key ID and secret for cli53
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Export zone parameters
DNSZONE='domain.tld'

# Use command line scripts to get instance ID and public hostname
INSTANCE_ID=$(ec2metadata --instance-id)
PUBLIC_HOSTNAME=$(ec2metadata --public-hostname)

# Create a new CNAME record on Route 53, replacing the old entry if nessesary
/usr/local/bin/cli53 rrcreate --replace $DNSZONE "`cat /etc/salt/minion_id|cut -d. -f1` CNAME $PUBLIC_HOSTNAME."
