#!/bin/sh
DEMOGAME='https://test.melvoridle.com/dlcPrep/assets/data/melvorDemo.json' 
BASEGAME='https://test.melvoridle.com/dlcPrep/assets/data/melvorFull.json' 
TOTHGAME='https://test.melvoridle.com/dlcPrep/assets/data/melvorTotH.json' 

MATCH="${1?Provide slot pls}"
if [ -z "$1" ]; then
	QUERY='.data.items[]'
elif [ "${1}" = "gear" ]; then
	QUERY='.data.items[] | select(has("validSlots"))'
else
	QUERY='.data.items[] | select(has("validSlots")) | select(.validSlots[] == "'${MATCH?}'")'
fi

curl -Ss "${DEMOGAME:?}" | jq "${QUERY:?}"
curl -Ss "${BASEGAME:?}" | jq "${QUERY:?}"
curl -Ss "${TOTHGAME:?}" | jq "${QUERY:?}"

