#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TS=$(date +%Y%m%dT%H%M%S%z)

if [[ $# -lt 2 ]]; then
	echo "usage: ${0} <method> <url> \"[curl options]\""
	echo
	echo "  method: each method is defined via the \"method.conf\" files, e.g.:"
	echo "    cmurl.sh URLDonwloadFile http://foobar.com"
	echo
	echo "  curl options: Optionally you can pass options to Curl, these must"
	echo "    be in quotes, otherwise only the first option is taken, e.g.:"
	echo "    cmurl.sh URLDonwloadFile http://foobar.com \"-k -L\""
	echo
	exit 1
fi

if [ ! -f "${DIR}/${1}.conf" ]; then
	echo "error: download method does not exist"
	exit 1
fi

if systemctl status tor > /dev/null; then
	PRECMD="torsocks"
fi

${PRECMD} curl -K "${DIR}/${1}.conf" -D cmurl-${1}-${TS}-headers.txt -o cmurl-${1}-${TS}-payload.bin ${3} "${2}"


