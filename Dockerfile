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
