#!/bin/bash


MMSUSER="${MMSUSER:-mongodb}"
MMSPID="${MMSPID:-/var/run/mongodb-mms-automation/mongodb-mms-automation-agent.pid}"

mkdir -p /opt/mms/rpm /opt/mms/tmp /etc/mongodb-mms/ /data/mms-logs /var/run/mongodb-mms-automation

echo "== Updating base OS"
apt-get update -qq -y && apt-get upgrade -qq -y

echo "== Downloading monitoring agent"
MA="https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb"
TF="/opt/mms/tmp/mongodb-mms_latest_amd64.ubuntu1604.deb"
curl -LsSf -o "$TF" "$MA" || exit 1

echo "== Installing monitoring agent"
touch "${MMSPID}"
getent passwd "$MMSUSER" && chown -R "$MMSUSER" /etc/mongodb-mms /data /var/run/mongodb-mms-automation "$MMSPID"
dpkg -i "$TF" || exit 2

umask 027

exec gosu "$MMSUSER:$MMSUSER" /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent -f "${MMS_CONFIG_FILE:-/etc/mongodb-mms/automation-agent.config}" -pidfilepath "$MMSPID"

