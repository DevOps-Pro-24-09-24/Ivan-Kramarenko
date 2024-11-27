#!/bin/bash
# Logging setup
log_file="/var/log/backup_db.log"
exec >> $log_file 2>&1

echo "$(date '+%F %T') - Starting database backup"

# Variables
timestamp=$(date +%F_%T)
backup_file="/tmp/app_db_backup_$timestamp.sql.gz"
s3_bucket=$(aws ssm get-parameter --name "/backup/s3-bucket" --query "Parameter.Value" --output text)

# Perform database backup and upload
mysqldump -u app_user -p"password" app_db | gzip > $backup_file
if [ $? -eq 0 ]; then
  echo "$(date '+%F %T') - Backup created: $backup_file"
  aws s3 cp $backup_file s3://$s3_bucket/
  if [ $? -eq 0 ]; then
    echo "$(date '+%F %T') - Backup uploaded to S3: s3://$s3_bucket/"
  else
    echo "$(date '+%F %T') - Failed to upload backup to S3"
  fi
else
  echo "$(date '+%F %T') - Failed to create backup"
fi

# Cleanup old backups
find /tmp -name "app_db_backup_*.sql.gz" -mtime +7 -delete
if [ $? -eq 0 ]; then
  echo "$(date '+%F %T') - Old backups deleted"
else
  echo "$(date '+%F %T') - Failed to delete old backups"
fi

echo "$(date '+%F %T') - Backup process completed"