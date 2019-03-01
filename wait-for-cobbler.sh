#!/bin/bash
echo "Waiting for Cobbler to become ready..."
ENDPOINT=https://127.0.0.1/cobbler_web
MAX_RETRIES=300
RETRY=1
while [[ "$HTTP_CODE" != "200" && $RETRY -lt $MAX_RETRIES ]]; do
	echo "Retrying $ENDPOINT (${RETRY}) ..."
	HTTP_CODE=$(curl --silent \
		--show-error \
		--fail -k -s -L \
		--retry 60 --retry-delay 2 \
		--max-time 30 \
		-o /dev/null \
		-w '%{http_code}' \
		$ENDPOINT)
	sleep 1
	RETRY=$((RETRY+1))
done
echo "Cobbler alive at $ENDPOINT"