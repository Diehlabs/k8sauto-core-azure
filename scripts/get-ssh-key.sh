#!/bin/bash
WS_ID="ws-UHmxNxemfWLqjU97"
CURRENT_STATE=`curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/workspaces/${WS_ID}/current-state-version"`
STATE_ID=`echo $CURRENT_STATE | jq .data.id -r`
echo "State ID: ${STATE_ID}"
URL="https://app.terraform.io/api/v2/state-versions/${STATE_ID}/outputs"
echo "URL: ${URL}"
STATE_OUTPUTS=`curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" $URL`
echo $STATE_OUTPUTS | jq -rC .data[0].attributes.value.private_key_pem > ./aks.key
chmod +x ./aks.key
echo "Key contents:"
cat ./aks.key
