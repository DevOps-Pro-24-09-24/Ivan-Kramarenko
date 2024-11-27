# Home Work 5

## Create AMI Image for Application with Packer

### Dependence:

Download and install Packer following HashiCorp's instructions: [Install Packer](https://developer.hashicorp.com/packer/install)

### Moving Packer files to the working directory:

- `app.pkr.hcl`: Configuration for application AMI.
- `db.pkr.hcl`: Configuration for database AMI.
- `plugins.pkr.hcl`: Optional plugins.
- `variables.pkrvars.hcl`: Contains variable values for Packer builds.

### Building AMI:

```bash
packer build -var-file=variables.pkrvars.hcl app.pkr.hcl
packer build -var-file=variables.pkrvars.hcl db.pkr.hcl
```

# Tasks with an asterisk:

Move the file: **app.service** to the directory:

```
sudo mv app.service /etc/systemd/system/
```

Start the service:

```
sudo systemctl daemon-reload
sudo systemctl enable app.service
sudo systemctl start app.service
```

Move the database backup script: **backup_db.sh** to the required directory:

```
sudo mv backup_db.sh /usr/local/bin/backup_db.sh
sudo chmod +x /usr/local/bin/backup_db.sh
```

Setting up cron to run the script:

```
(crontab -l ; echo "0 1 * * * /usr/local/bin/backup_db.sh") | crontab -
```
