FROM ubuntu:xenial

# Update and install Nginx
RUN apt-get update && apt-get install nginx -y

# Collects DOMAIN argument
ARG DOMAIN

# Collects TARGET argument
ARG TARGET

# Collects PORT argument
ARG PORT

# Sets the workdir
WORKDIR /app

# Copies ssl folder
COPY start.sh .

# Copies ssl folder
COPY ssl .

# Copies default file to sites-available
COPY default /etc/nginx/sites-available

# Sets the exec permission to start.sh file
RUN chmod +x ./start.sh && ls -la ./

# Sets DOMAIN env var with DOMAIN arg value
ENV DOMAIN=${DOMAIN}

# Updates default file with correct values
RUN sed -i "s|##DOMAIN##|${DOMAIN}|g" /etc/nginx/sites-available/default
RUN sed -i "s|##TARGET##|${TARGET}|g" /etc/nginx/sites-available/default
RUN sed -i "s|##PORT##|${PORT}|g" /etc/nginx/sites-available/default

# Runs start.sh script
ENTRYPOINT [ "./start.sh" ]
