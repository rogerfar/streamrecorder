FROM alpine:latest

# Install VLC
RUN apk add --no-cache vlc openrc busybox-openrc tzdata

# Create a directory for your scripts and output files
RUN mkdir /app
RUN mkdir /out
WORKDIR /app

RUN mkdir -p /etc/cron.d

RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

RUN cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
RUN echo "Europe/Amsterdam" > /etc/timezone

# Copy your scripts into the container
COPY record.sh /app/
COPY generate_cron_jobs.sh /app/

# Give execution rights to the scripts
RUN chmod +x /app/record.sh && \
    chmod +x /app/generate_cron_jobs.sh

# Run the script to generate cron jobs and start cron daemon
CMD ["/bin/sh", "-c", "/app/generate_cron_jobs.sh && crond -f -d 8"]