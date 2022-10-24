#!/bin/sh
#
# A script to query thieving targets in the game.
# Usage:
#	thieving.sh [option]
#	option:
#		- unique
#			lists all unique drops of all targets
#		- target name
#			provides all details of the target
#
#
#
MAIN_RELEASE='https://melvoridle.com/assets/data'
TEST_RELEASE='https://test.melvoridle.com/dlcPrep/assets/data'
BASEPATH="${MAIN_RELEASE}"

BASEGAME="${BASEPATH:?}/melvorFull.json"
DEMOGAME="${BASEPATH:?}/melvorDemo.json"
TOTHGAME="${BASEPATH:?}/melvorTotH.json" 

MATCH="${1}"
if [ -z "$MATCH" ]; then
	QUERY='.data'
else
	case "${MATCH}" in
		unique)
			QUERY='.data.skillData[] | select(.skillID == "melvorD:Thieving") | .data.npcs[] | { name, uniqueDrop }'
			;;
		*)
			QUERY='.data.skillData[] | select(.skillID == "melvorD:Thieving") | .data.npcs[] | select(.name | test(".*'${MATCH}'.*"))'
			;;
	esac
fi

curl -Ss "${DEMOGAME:?}" | jq "${QUERY:?}"
curl -Ss "${BASEGAME:?}" | jq "${QUERY:?}"
curl -Ss "${TOTHGAME:?}" | jq "${QUERY:?}"

