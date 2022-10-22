#!/bin/sh
#
# A script to query items in the game.
# Usage:
#	items.sh [selection]
#	selection:
#		- "gear": all equippable items
#		- slot: any specific slot, must be capitalized
#
MAIN_RELEASE='https://melvoridle.com/assets/data'
TEST_RELEASE='https://test.melvoridle.com/dlcPrep/assets/data'
BASEPATH="${MAIN_RELEASE}"

BASEGAME="${BASEPATH:?}/melvorFull.json"
DEMOGAME="${BASEPATH:?}/melvorDemo.json"
TOTHGAME="${BASEPATH:?}/melvorTotH.json" 

MATCH="${1?Provide slot pls}"
if [ -z "$1" ]; then
	QUERY='.data.items[]'
else
	case "${1}" in
		gear)
			QUERY='.data.items[] | select(has("validSlots"))'
			;;
		Passive|Cape)
			QUERY='.data.items[] | select(has("validSlots")) | select(.validSlots[] == "'${MATCH?}'")'
			;;
		*)
			QUERY='.data.items[] | select(.name == ".*'${MATCH?}'.*")'
			;;
	esac
fi

curl -Ss "${DEMOGAME:?}" | jq "${QUERY:?}"
curl -Ss "${BASEGAME:?}" | jq "${QUERY:?}"
curl -Ss "${TOTHGAME:?}" | jq "${QUERY:?}"

