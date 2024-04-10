#!/bin/sh

# Set default username if SSH_USER is not set
DEFAULT_USER="user"
if [ -z "$SSH_USER" ]; then
    SSH_USER=$DEFAULT_USER
fi

# Set default password if SSH_PASSWORD is not set
DEFAULT_PASSWORD="password"
if [ -z "$SSH_PASSWORD" ]; then
    SSH_PASSWORD=$DEFAULT_PASSWORD
fi

# Check if the default user exists, if not, create it
if ! id -u $SSH_USER > /dev/null 2>&1; then
    adduser -D $SSH_USER
fi
# Add user and set password
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
echo "$SSH_USER:$SSH_PASSWORD"
# Start SSH server
/usr/sbin/sshd -D
