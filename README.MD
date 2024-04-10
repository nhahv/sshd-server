# Simple SSH Server on Alpine

- Allow Password Authentication
- Permit Root Login as Optional 
- `SSH_USER`: for run with custome user: Default (user)
- `SSH_PASSWORD`: for set password for user: Default (password)

Clear Text Passwords are not recommended, use it for testing purpose only

Docker file content 
```Dockefile
# Use Alpine Linux as base image
FROM alpine:latest

# Install OpenSSH server
RUN apk --no-cache add openssh-server

# Enable password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Permit root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# Generate SSH host keys
RUN ssh-keygen -A

# Set up entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose SSH port
EXPOSE 22

# Start SSH server
ENTRYPOINT ["/entrypoint.sh"]
```

Entrypoint file content

```sh
#!/bin/sh

# Set default username if SSH_USER is not set
DEFAULT_USER="root"
if [ -z "$SSH_USER" ]; then
    SSH_USER=$DEFAULT_USER
fi

# Set default password if SSH_PASSWORD is not set
DEFAULT_PASSWORD="123456"
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
```