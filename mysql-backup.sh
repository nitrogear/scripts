#!/bin/bash

USER=<change me>
PASS=<change me>
LOG_FILE="/var/log/mysql-backup.log"
BACKUP_DIR="/root/backups"
HOSTNAME=$(hostname)

S3CMD="/usr/local/bin/s3cmd"
MYSQLDUMP="/usr/bin/mysqldump"
mkdir -p ${BACKUP_DIR}

DATE=$(date +"%m%d%Y-%H-%M")

mkdir -p ${BACKUP_DIR}

MYSQL_HOST="localhost"
DATABASE="main"
D=$(date +%Y%m%d)

echo ${DATE}" Backup started" >> ${LOG_FILE}
echo ${MYSQLDUMP} -h${MYSQL_HOST} -u ${USER} -p${PASS} ${DATABASE} >> ${LOG_FILE}

${MYSQLDUMP} -h${MYSQL_HOST} -u ${USER} -p${PASS} ${DATABASE} 2>>${LOG_FILE} | gzip -9 > ${BACKUP_DIR}/dump-${D}.sql.gz
tar -czf ${BACKUP_DIR}/html-uploads-${D}.tar.gz /var/www/html/uploads 2>/dev/null

# generate s3 config
PASSWORD=$(pwgen -c -n -s 30 1)

cat /root/.s3cfg__template | sed "s/__GPG_PASSPHRASE__/${PASSWORD}/g" > /root/.s3cfg

${S3CMD} put -e ${BACKUP_DIR}/dump-${D}.sql.gz s3://bp-mysql-backups 2>>${LOG_FILE} >> ${LOG_FILE}
${S3CMD} put -e ${BACKUP_DIR}/html-uploads-${D}.tar.gz s3://bp-mysql-backups 2>>${LOG_FILE} >> ${LOG_FILE}
echo ${PASSWORD} > ${BACKUP_DIR}/backup-${D}.password

cat /root/.s3cfg__original > /root/.s3cfg

${S3CMD} put ${BACKUP_DIR}/backup-${D}.password s3://bp-backups-keys 2>>${LOG_FILE} >> ${LOG_FILE}

pwgen -c -n -s 30 1 > ${BACKUP_DIR}/backup-${D}.password
rm -f ${BACKUP_DIR}/backup-${D}.password
rm -f ${BACKUP_DIR}/dump-${D}.sql.gz
rm -f ${BACKUP_DIR}/html-uploads-${D}.tar.gz

DATE=$(date +"%m%d%Y-%H-%M")
echo ${DATE}" Backup finished" >> ${LOG_FILE}