# **nfs_backup**

Script that creates a time-stamped `.tar` archive of 
specified directories and copies it to a NFS drive.  

It is not the most sophisticated tool but I use it
quite often in backing up data from VMs to my local 
NFS server.

# Usage
To run the script, type:

    bash nfs_backup.sh <nfs_address> dir1 dir2 ...

Example:

    sudo bash nfs_backup.sh 192.168.0.69 /home/mike /www /etc

## History
*  2019/12/19 : michal-nawrocki : Script upload