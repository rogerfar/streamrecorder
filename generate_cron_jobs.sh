#!/bin/sh

echo "Starting to generate cron jobs..."

# Check if the JOBS variable is set
if [ -z "$JOBS" ]; then
    echo "The JOBS variable is not set. Exiting."
    exit 1
fi

echo "Number of jobs to create: $JOBS"

# Ensure /etc/cron.d directory exists
mkdir -p /etc/cron.d
echo "Ensured /etc/cron.d directory exists."

# Create a new cron file
echo "" > /etc/cron.d/vlc_jobs
echo "Created /etc/cron.d/vlc_jobs file."

# Loop through the number of jobs
i=1
while [ $i -le $JOBS ]; do
    echo "Creating job $i..."

    # Fetch variables for each job using eval
    eval URL=\$JOB${i}_URL
    eval START_TIME=\$JOB${i}_START_TIME
    eval RUNTIME=\$JOB${i}_RUNTIME
    eval OUTPUT_PATH=\$JOB${i}_OUTPUT_PATH
    eval FILENAME=\$JOB${i}_FILENAME
    eval TIMEZONE=\$JOB${i}_TIMEZONE

    echo "Job $i details:"
    echo "URL: $URL"
    echo "Start Time: $START_TIME"
    echo "Runtime: $RUNTIME"
    echo "Output Path: $OUTPUT_PATH"
    echo "Filename: $FILENAME"
    echo "Timezone: $TIMEZONE"

    # Convert start time to cron format
    HOUR=$(echo $START_TIME | cut -d':' -f1)
    MINUTE=$(echo $START_TIME | cut -d':' -f2)

    # Create the cron job
    CRON_JOB="$MINUTE $HOUR * * * TZ=$TIMEZONE /app/record.sh \"$URL\" \"$OUTPUT_PATH\" \"$FILENAME\" $RUNTIME >> /app/cron-$FILENAME.log 2>&1"
    echo "Cron job command: $CRON_JOB"
    echo "$CRON_JOB" >> /etc/cron.d/vlc_jobs

    i=$((i + 1)) # Increment the loop variable
done

echo "Cron jobs creation completed."


# Apply the cron jobs
chmod 0644 /etc/cron.d/vlc_jobs
crontab /etc/cron.d/vlc_jobs
