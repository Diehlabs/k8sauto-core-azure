#!/bin/bash
WS_NAME="k8sauto-core-azure"

WS_DATA=`curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" https://app.terraform.io/api/v2/organizations/Diehlabs/workspaces/${WS_NAME}`
# echo $WS_DATA | jq -C # debug -print whole response
WS_ID=`echo $WS_DATA | jq .data.id`
echo "WS ID: ${WS_ID}"
#CURRENT_STATE=`curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/workspaces/${WS_ID}/current-state-version"`
CURRENT_STATE=`echo $WS_DATA | jq .data.relationships.\"current-state-version\"`
echo "Current state version: ${CURRENT_STATE}"
STATE_ID=`echo $CURRENT_STATE | jq .data.id -r`
echo "State ID: ${STATE_ID}"
URL="https://app.terraform.io/api/v2/state-versions/${STATE_ID}/outputs"
echo "URL: ${URL}"
STATE_OUTPUTS=`curl --header "Authorization: Bearer $TFE_TOKEN" --header "Content-Type: application/vnd.api+json" $URL`
echo $STATE_OUTPUTS | jq -C
echo $STATE_OUTPUTS | jq -rC .data[0].attributes.value.private_key_pem > ~/.ssh/k8sauto_rsa
chmod 600 ~/.ssh/k8sauto_rsa
echo "Key contents:"
cat ~/.ssh/k8sauto_rsa
