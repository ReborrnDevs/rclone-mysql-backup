#!/usr/bin/env bash

set -euo pipefail

TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
ARCHIVE="backup-${TIMESTAMP}.tar"

mydumper --host "$MYSQL_HOST" --user "$MYSQL_USER" --password "$MYSQL_PASSWORD" --port "$MYSQL_PORT" --database "$MYSQL_DATABASE" -C -c --clear -o backup

tar -cf "$ARCHIVE" backup/

rclone config touch
cat <<EOF > ~/.config/rclone/rclone.conf
[remote]
type = s3
provider = Cloudflare
access_key_id = $R2_ACCESS_KEY_ID
secret_access_key = $R2_SECRET_ACCESS_KEY
endpoint = $R2_ENDPOINT
acl = private
no_check_bucket = true
EOF

rclone copyto "$ARCHIVE" remote:"$R2_BUCKET"/"$R2_PATH"/"$ARCHIVE"