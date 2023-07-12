#!/bin/bash
set -eo pipefail

STATUS=0
NSSF_INTERFACE_NAME_FOR_SBI=$(yq '.nfs.nssf.sbi.interface_name' /openair-nssf/etc/config.yaml)
NSSF_INTERFACE_PORT_FOR_SBI=$(yq '.nfs.nssf.sbi.port' /openair-nssf/etc/config.yaml)

NSSF_IP_SBI_INTERFACE=$(ifconfig $NSSF_INTERFACE_NAME_FOR_SBI | grep inet | grep -v inet6 | awk {'print $2'})
#Check if entrypoint properly configured the conf file and no parameter is unset(optional)
NSSF_SBI_PORT_STATUS=$(netstat -tnpl | grep -o "$NSSF_IP_SBI_INTERFACE:$NSSF_INTERFACE_PORT_FOR_SBI")

if [[ -z $NSSF_SBI_PORT_STATUS ]]; then
	STATUS=-1
	echo "Healthcheck error: UNHEALTHY SBI TCP/HTTP port $NSSF_INTERFACE_PORT_FOR_SBI is not listening."
fi

exit $STATUS
