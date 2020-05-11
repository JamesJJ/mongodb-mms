#!/bin/bash

MMSPID="${MMSPID:-/var/run/mongodb-mms-automation/mongodb-mms-automation-agent.pid}"

PROCSTATUS="/proc/$(cat "$MMSPID")/status"

if [ ! -f "$PROCSTATUS" ]; then exit 2; fi

grep -E '^State:[[:space:]][RS]' < "$PROCSTATUS" || exit 1

exit 0


