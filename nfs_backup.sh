#!/bin/sh

#================================================================
# HEADER
#================================================================
#  USAGE
#     nfs_backup.sh <nfs_address> dir1 dir2 ...
# 
#  DESCRIPTION
#     Backup directories to NFS drive.
#     Mount NFS drive and upload a tar with backups of specified dirs.
#     The output tar has the file name set to current time.
# 
#  EXAMPLES
#     nfs_backup.sh 192.168.0.66 /home/mike /etc /www
# 
#================================================================
#  IMPLEMENTATION
#    version         nfs_backup (github.com/michal-nawrocki) 0.0.1
#    author          Mike Nawrocki 
#    copyright       Copyright (c) https://nawrocki.dev
#    license         GNU General Public License
#
#================================================================
#  HISTORY
#     2019/12/19 : michal-nawrocki : Script creation
# 
#================================================================
# END_OF_HEADER
#================================================================

# Get ip_address from arguments
server_ip_address="$1"

# Check if the ip_address is not empty
if [ -z "$server_ip_address" ]
then
    echo "Usage: bash nfs_backup.sh <nfs_address> (dir1 dir2 ...)"
    echo "Exiting..."
    exit 1
fi

# Shift the input to get the list of directories
shift

# Get the list of dirs
dirs_to_backup=("$*")

# Check if the list of directories is not empty
if [ -z "$dirs_to_backup" ]
then
    echo "Usage: bash nfs_backup.sh <nfs_address> dir1 dir2 ..."
    echo "Exiting..."
    exit 1
fi

# Make dir for mounted NFS drive
sudo mkdir /mnt/nfs_backup > /dev/null

# Make sure that nothing is mounted to that directory
sudo umount -f -l /mnt/nfs_backup > /dev/null

# Mount drive
sudo mount -t nfs $server_ip_address:/backups /mnt/nfs_backup > /dev/null

# Check if mounting succeded
if [ $? -ne 0 ]
then
    echo "Mounting of NFS drive failed"
    echo "Exiting..."
    exit 1
fi

# Get date for filename
now=$(date +%Y-%m-%d-%H-%M-%S)

# Make archive in /var/backups
sudo tar -cf /mnt/nfs_backup/$now.tar "$dirs_to_backup" > /dev/null

# Check if archive works and print corresponding info
if [ $? -eq 0 ]; then
    echo "Backup completed successfully" 
else
    echo "Backup failed"
fi

# Cleanup - Unmount the drive and delete temp dir
sudo umount -f -l /mnt/nfs_backup > /dev/null
sudo rm -rf /mnt/nfs_backup > /dev/null
