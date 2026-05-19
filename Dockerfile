# syntax=docker/dockerfile:1

FROM rclone/rclone:1.74.1 as rclone

FROM mydumper/mydumper:v0.21.3-2

COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/rclone

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV MYSQL_PORT="3306"
ENV R2_PATH="mysql-backup"

CMD ["/entrypoint.sh"]
