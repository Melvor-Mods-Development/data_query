#!/bin/sh
#
# A script to query monsters in the game.
# Usage:
#	monsters.sh [monster name]
#
MAIN_RELEASE='https://melvoridle.com/assets/data'
TEST_RELEASE='https://test.melvoridle.com/dlcPrep/assets/data'
BASEPATH="${MAIN_RELEASE}"

BASEGAME="${BASEPATH:?}/melvorFull.json"
DEMOGAME="${BASEPATH:?}/melvorDemo.json"
TOTHGAME="${BASEPATH:?}/melvorTotH.json" 

MATCH="${1}"
if [ -z "$MATCH" ]; then
	QUERY='.data.dungeons[]'
else
	case "${MATCH}" in
		*)
			QUERY='.data.dungeons[] | select(.name | test(".*'${MATCH}'.*"))'
			;;
	esac
fi

curl -Ss "${DEMOGAME:?}" | jq "${QUERY:?}"
curl -Ss "${BASEGAME:?}" | jq "${QUERY:?}"
curl -Ss "${TOTHGAME:?}" | jq "${QUERY:?}"

