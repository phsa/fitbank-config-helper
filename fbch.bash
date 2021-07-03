#!/bin/bash

handle_wild_chars() {
	local RESULT=$(echo "$1" | sed 's|\\|\\\\|g')
	echo "$RESULT" | sed 's|/|\\/|g'
}

replace_in_conn_strs()
{
	local FIELD=$(handle_wild_chars "$1")
	local REPLACEMENT=$(handle_wild_chars "$2")
	local FILE_PATH=$3
	
	# echo "replace_in_conn_strs: FILED = $1"
	# echo "replace_in_conn_strs: REPLACEMENT = $2"
	# echo "replace_in_conn_strs: FILE_PATH = $3"
	
	sed -i "s/${FIELD}=[^;]*;/${FIELD}=${REPLACEMENT};/g" $FILE_PATH
	echo "${FIELD} has been updated successfully in ${FILE_PATH}"
}


replace_in_configs()
{

	local FIELD=$1
	local REPLACEMENT=$2
	
	# echo "replace_in_configs: FIELD = $1"
	# echo "replace_in_configs: REPLACEMENT = $2"
	
	replace_in_conn_strs "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Address.Api/Web.config'
	replace_in_conn_strs "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Api.Rest/Web.config'
	replace_in_conn_strs "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Web.UI/Web.config'
	replace_in_conn_strs "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Portal.UI/Web.config'
	replace_in_conn_strs "$FIELD" "$REPLACEMENT" 'fb_solution/FB.AppApi.Rest/Web.config'
}


if [ ! -z "$1" ]
	then
		if [[ "$1" -eq "setting" ]]
			then
				echo "add | reset "
		else
			# echo "$1"
			# replace_in_conn_strs "Password" $1 Web.config
			replace_in_configs "Password" "$1"
		fi
else
	echo "No arguments supplied"
fi

if [ ! -z "$2" ]
	then
		# echo "$2"
		# replace_in_conn_strs "User ID" $2 Web.config
		replace_in_configs "User ID" "$2"
fi

# if [[ ! -z "$3" && ! -z "$4" ]]
if [ ! -z "$3" ]
	then
		# echo "$3"
		# replace_in_conn_strs "Data Source" $DATA_SOURCE_VALUE Web.config
		replace_in_configs "Data Source" "$3"
fi