#!/bin/bash
handle_wild_chars() {
	local RESULT
	# echo "handle_wild_chars: $1"
	RESULT="${1/\\/\\\\}"
	echo "${RESULT///\\/}"
}

update_conn_str()
{
	local FIELD
	local REPLACEMENT
	local FILE_PATH
	
	FIELD=$(handle_wild_chars "$1")
	REPLACEMENT=$(handle_wild_chars "$2")
	FILE_PATH=$3
	
	# echo "update_conn_str: FILED = $FIELD"
	# echo "update_conn_str: REPLACEMENT = $REPLACEMENT"
	# echo "update_conn_str: FILE_PATH = $FILE_PATH"
	
	if ! sed -i "s/${FIELD}=[^;]*;/${FIELD}=${REPLACEMENT};/g" "$FILE_PATH"
		then
			echo "Unable to update ${FIELD} in ${FILE_PATH} file"
	fi
}


update_specific_field_solution_conn_strs()
{
	local FIELD=$1
	local REPLACEMENT=$2
	
	# echo "update_specific_field_solution_conn_strs: FIELD = $FIELD"
	# echo "update_specific_field_solution_conn_strs: REPLACEMENT = $REPLACEMENT"
	
	update_conn_str "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Address.Api/Web.config'
	update_conn_str "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Api.Rest/Web.config'
	update_conn_str "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Web.UI/Web.config'
	update_conn_str "$FIELD" "$REPLACEMENT" 'fb_solution/FB.Portal.UI/Web.config'
	update_conn_str "$FIELD" "$REPLACEMENT" 'fb_solution/FB.AppApi.Rest/Web.config'
}

update_solution_conn_strs() {
	if [ -n "$1" ]; then
		# echo "update_solution_conn_strs: $1"
		update_specific_field_solution_conn_strs "Password" "$1"
	else
		echo "solution_cmd: No arguments provided to update connection strings."
	fi

	if [ -n "$2" ]; then
		# echo "update_solution_conn_strs: $2"
		update_specific_field_solution_conn_strs "User ID" "$2"
	fi

	if [ -n "$3" ];	then
		# echo "update_solution_conn_strs: $3"
		update_specific_field_solution_conn_strs "Data Source" "$3"
	fi
}


solution__settings() {
	echo "NotImplemented: add setting to appSettings block"
}

solution() {
	local SOLUTION_CMD='solution'
	local FIRST_ARG="$1";
	if type "${SOLUTION_CMD}__${FIRST_ARG}" >/dev/null 2>&1; then
		shift
		"${SOLUTION_CMD}__${FIRST_ARG}" "$@"
	elif [[ $# -gt 0 && $# -lt 4 ]]; then
		update_solution_conn_strs "$@"
	elif [ $# -eq 0 ]; then
		echo "solution_cmd: No arguments provided to update connection strings."
	else
		echo "solution_cmd: There is no '${FIRST_ARG}' subcommand for the '${SOLUTION_CMD}' command" >&2
		exit 1
	fi
}


# make sure we actually *did* get passed a valid function name
if declare -f "$1" >/dev/null 2>&1; then
	"$@"
else
	echo "fbch: There is no '$1' command in fbch.bash" >&2
	exit 1
fi