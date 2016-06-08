#!/bin/bash
# Program: start.sh
# Purpose: this shell script will create a user with password
# Author:  ray lai
# Updated: Feb 11, 2016
#
__create_user() {
# Define user and password here
SSH_USER=gmat
SSH_ADMIN1=audacy
SSH_ADMIN2=user2
SSH_ADMIN3=user3
SSH_USERPASS=xxx

# create user logic
useradd $SSH_USER
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_USER)
echo ssh user password: $SSH_USERPASS

useradd $SSH_ADMIN1
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_ADMIN1)
echo ssh admin-user  password: $SSH_USERPASS

useradd $SSH_ADMIN2
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_ADMIN2)
echo ssh admin-user  password: $SSH_USERPASS

useradd $SSH_ADMIN3
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_ADMIN3)
echo ssh admin-user  password: $SSH_USERPASS
}

__make_sudoers() {
  echo "$SSH_USER    ALL=(ALL:ALL) ALL" >> /etc/sudoers;
  echo "$SSH_ADMIN1  ALL=(ALL:ALL) ALL" >> /etc/sudoers;
  echo "$SSH_ADMIN2  ALL=(ALL:ALL) ALL" >> /etc/sudoers;
  echo "$SSH_ADMIN3  ALL=(ALL:ALL) ALL" >> /etc/sudoers;
}


# execute create user
__create_user
__make_sudoers
