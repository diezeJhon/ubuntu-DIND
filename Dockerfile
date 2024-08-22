# Use Ubuntu as the base image
FROM ubuntu:focal-20221130
# Set environment variable to skip the interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies for Docker
RUN apt-get update && apt-get install -y \
       apt-transport-https \
       ca-certificates \
       curl \
       software-properties-common \
       gnupg \  
       apt-utils \
       curl \
       cmake \
       dirmngr \
       gnupg \
       apt-transport-https \
       ca-certificates \
       software-properties-common \
       postgresql-client \
       swig \
       wget \
       python python3.7 python3-pip \
       git \
       vim \
       openssh-client \
       apache2-utils \
       libcairo2-dev \
       libpango1.0-dev \
       libjpeg-dev \
       libgif-dev \
       librsvg2-dev \
       libpixman-1-dev \
       pkg-config \
       lsb-release

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker repository
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Install Docker
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Free up UID and GID 1000 by modifying the existing user/group
RUN if getent passwd 1000; then \
        usermod -u 999 -o $(getent passwd 1000 | cut -d: -f1); \
    fi && \
    if getent group 1000; then \
        groupmod -g 999 -o $(getent group 1000 | cut -d: -f1); \
    fi

# Clean up unnecessary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Command to start the Docker daemon
CMD ["dockerd"]
