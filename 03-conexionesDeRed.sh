#! /bin/bash
function find_property_value {

	PROPERTY_PATTERN=$1
	PROPERTY_VALUE=$(ifconfig $interface | \
		grep $PROPERTY_PATTERN | \
		awk -v pattern="$PROPERTY_PATTERN" '
		{
			for(i=1;i<=NF;i++)
				if($i==pattern)
					print $(i+1)
		}'
	)

	if [[ -z $PROPERTY_VALUE ]]
	then
		echo "-"
	else
		echo $PROPERTY_VALUE
	fi
}

INTERFACES=()
iterator=1

# Loop until grep command returns empty and save in array
while [ $iterator -lt 10 ]
do
  INTERFACE_OUTPUT=$(ip address | grep ^$iterator: | awk '{print $2}')
  if [[ -z $INTERFACE_OUTPUT ]]; then
    break
  fi
  # Once we know it exists, add to array
  # Remove trailing ":" char
  INTERFACES+=("${INTERFACE_OUTPUT%:*}")
  ((iterator++))
done

for interface in "${INTERFACES[@]}"
do
	IPV4=$(find_property_value inet)
	NETMASK=$(find_property_value netmask)
	BROADCAST=$(find_property_value broadcast)
	MTU=$(find_property_value mtu)
	MAC_ADDRESS=$(find_property_value ether)
	IPV6=$(find_property_value inet6)
	IPV6_SCOPE=$(find_property_value scopeid)
	IPV6_PREFIX_LENGTH=$(find_property_value prefixlen)
	echo Interface: $interface
	echo MAC Address: $MAC_ADDRESS
	echo IPv4: $IPV4
	echo Netmask: $NETMASK
	echo Broadcast: $BROADCAST
	echo MTU: $MTU
	echo IPv6: $IPV6
	echo Scope: $IPV6_SCOPE
	echo Prefix Lenght: $IPV6_PREFIX_LENGTH
	echo "-------------"
done

# inet IPv4 ADDRESS
# netmask IPv4 NETMASK	 
# broadcast BROADCAST
# state (ipaddress) Flags include UP 
# mtu	Maximum Transition Unit
# ether	MAC Address
# scope Host, Local, Global



## RX TX 

# 					Interface: lo
# State 								UP
# MAC Address							f0:2f:74:47:3d:30
# MTU 								1500	
# -------------------- IPv4 ------------------------
# IPv4 Address						127.0.0.1					
# Netmask								255.0.0.					-
# Broadcast							192.168.1.255
# -------------------- IPv6 ------------------------
# IPv6 Address						::1					
# Prefix Lenght						64
# Scope								Local

# ----------- RX ---------- | ----------- TX -----------
# Packets: 			   66 | Packets: 				67
# Bytes: 			   (0.0B) | Bytes:	 			(0.0B)
# AErrors: 		   		0 | Errors: 				 0	
# Dropped: 		   		0 | Dropped: 				 0	
# Overruns: 		   		0 | Overruns: 				 0	
# Carriers: 		   		0 | Carriers: 				 0	
# Collision: 		   		0 | Collision: 				 0