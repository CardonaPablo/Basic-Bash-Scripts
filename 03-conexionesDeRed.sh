#! /bin/bash


# 					Interface: lo
# State 								UP
# MAC Address							f0:2f:74:47:3d:30
# MTU 									1500	
# -------------------- IPv4 ------------------------
# IPv4 Address							127.0.0.1					
# Netmask								255.0.0.					-
# Broadcast								192.168.1.255
# -------------------- IPv6 ------------------------
# IPv6 Address							::1					
# Prefix Lenght							64
# Scope									Local

# ----------- RX ------------ | ----------- TX -----------
# Packets:			       66 | Packets: 				67
# Bytes: 			   (0.0B) | Bytes:	 			(0.0B)
# Errors:			   	    0 | Errors: 				 0	
# Dropped: 		   			0 | Dropped: 				 0	
# Overruns: 		   		0 | Overruns: 				 0	
# Carriers: 		   		0 | Carriers: 				 0	
# Collision: 		   		0 | Collision: 				 0

# inet IPv4 ADDRESS
# netmask IPv4 NETMASK	 
# broadcast BROADCAST
# state (ipaddress) Flags include UP 
# mtu	Maximum Transition Unit
# ether	MAC Address
# scope Host, Local, Global

ROW_FORMAT="| \e[1;34m%-36s\e[0m %20s |\n"
ROW_FORMAT_ITALIC="| \e[1;33m%-36s\e[0m \e[3m%20s\e[0m |\n"
HALF_ROW_FORMAT="| \e[34m%-16s\e[0m \e[3m%10s\e[0m "

function find_property_value {
	PROPERTY_PATTERN=$1
	PROPERTY_VALUE=$(ifconfig $interface | \
		grep "$PROPERTY_PATTERN" | \
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

function find_RX_TX_property_value {

	PROPERTY_PATTERN=$1
	GREP_PATTERN=$2

	PROPERTY_VALUE=$(ifconfig $interface | \
		grep "$GREP_PATTERN" | \
		awk -v pattern="$PROPERTY_PATTERN" '
		{
			for(i=1;i<=NF;i++)
				if($i==pattern)
					print $(i+1)
		}'
	)

	echo $PROPERTY_VALUE
}

function print_section_title {
	separator=---------------------------- 
	printf "%s \e[4m%s\e[0m %s\n" $separator $1 $separator
}

function print_main {

	echo ""
	echo ""
	
	MTU=$(find_property_value mtu)
	MAC_ADDRESS=$(find_property_value ether)

	INTERFACE_NAME=$1
	printf "%20s %s \e[47;30m%s\e[0m\n" " " "Interface:" $INTERFACE_NAME
	# printf "%25s \e[47m%s\e[0m\n" " " $INTERFACE_NAME
	# printf "$ROW_FORMAT" "State" $STATE
	printf "$ROW_FORMAT_ITALIC" "MAC Address" $MAC_ADDRESS
	printf "$ROW_FORMAT" "MTU" $MTU

	# 					Interface: lo
	# State 								UP
	# MAC Address							f0:2f:74:47:3d:30
	# MTU 								    1500
}

function print_ipv4 {

	IPV4=$(find_property_value inet)
	NETMASK=$(find_property_value netmask)
	BROADCAST=$(find_property_value broadcast)

	if [[ $IPV4 = '-' ]]
	then
		return
	fi

	print_section_title "IPv4"
	printf "$ROW_FORMAT_ITALIC" "Ipv4 Address" $IPV4
	printf "$ROW_FORMAT" "Netmask" $NETMASK
	printf "$ROW_FORMAT" "Broadcast" $BROADCAST


# -------------------- IPv4 ------------------------
# IPv4 Address						127.0.0.1					
# Netmask								255.0.0.					-
# Broadcast							192.168.1.255
}

function print_ipv6 {

	IPV6=$(find_property_value inet6)
	IPV6_SCOPE=$(find_property_value scopeid)
	IPV6_PREFIX_LENGTH=$(find_property_value prefixlen)

	if [[ $IPV6 = '-' ]]
	then
		return
	fi

	print_section_title "IPv6"
	printf "$ROW_FORMAT_ITALIC" "Ipv6 Address" $IPV4
	printf "$ROW_FORMAT" "Prefix length" $IPV6_PREFIX_LENGTH
	printf "$ROW_FORMAT" "Scope" $IPV6_SCOPE


# -------------------- IPv6 ------------------------
# IPv6 Address						::1					
# Prefix Lenght						64
# Scope								Local

}

function print_rx_tx {

	separator=------------- 
	printf "%s \e[4m%s\e[0m %s|" $separator "RX" $separator
	printf "%s \e[4m%s\e[0m %s\n" $separator "TX" $separator

	RX_PACKETS=$(find_RX_TX_property_value packets RX)
	RX_BYTES=$(find_RX_TX_property_value bytes RX)
	RX_ERRORS=$(find_RX_TX_property_value errors RX)
	RX_DROPPED=$(find_RX_TX_property_value dropped RX)
	RX_OVERRUNS=$(find_RX_TX_property_value overruns RX)
	RX_FRAME=$(find_RX_TX_property_value frame RX)

	TX_PACKETS=$(find_RX_TX_property_value packets TX)
	TX_BYTES=$(find_RX_TX_property_value bytes TX)
	TX_ERRORS=$(find_RX_TX_property_value errors TX)
	TX_DROPPED=$(find_RX_TX_property_value dropped TX)
	TX_OVERRUNS=$(find_RX_TX_property_value overruns TX)
	TX_CARRIER=$(find_RX_TX_property_value carrier TX)
	TX_COLLISIONS=$(find_RX_TX_property_value collisions TX)

	printf "$HALF_ROW_FORMAT" "Packets" $RX_PACKETS
	printf "$HALF_ROW_FORMAT" "Packets" $TX_PACKETS
	printf "%s\n" "|"

	printf "$HALF_ROW_FORMAT" "Bytes" $RX_BYTES
	printf "$HALF_ROW_FORMAT" "Bytes" $TX_BYTES
	printf "%s\n" "|"

	printf "$HALF_ROW_FORMAT" "Errors" $RX_ERRORS
	printf "$HALF_ROW_FORMAT" "Errors" $TX_ERRORS
	printf "%s\n" "|"

	printf "$HALF_ROW_FORMAT" "Dropped" $RX_DROPPED
	printf "$HALF_ROW_FORMAT" "Dropped" $TX_DROPPED
	printf "%s\n" "|"

	printf "$HALF_ROW_FORMAT" "Overruns" $RX_OVERRUNS
	printf "$HALF_ROW_FORMAT" "Overruns" $TX_OVERRUNS
	printf "%s\n" "|"

	printf "$HALF_ROW_FORMAT" "Frame" $RX_FRAME
	printf "$HALF_ROW_FORMAT" "Carrier" $TX_CARRIER
	printf "%s\n" "|"

	printf "$HALF_ROW_FORMAT" "" ""
	printf "$HALF_ROW_FORMAT" "Collisions" $TX_COLLISIONS
	printf "%s\n" "|"


# (30)							(30) 
# ----------- RX ------------ | ----------- TX -----------
# Packets:			       66 | Packets: 				67
# Bytes: 			   	 0.0B | Bytes:	 			  0.0B
# Errors:			   	    0 | Errors: 				 0	
# Dropped: 		   			0 | Dropped: 				 0	
# Overruns: 		   		0 | Overruns: 				 0	
# Frame: 		   			0 | Carrier: 				 0	
# 							  | Collisions: 			 0
}

function run {
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
		print_main $interface
		print_ipv4 $interface
		print_ipv6 $interface
		print_rx_tx $interface
	done
}

run | more -22