FROM python:3

WORKDIR /usr/src/app
RUN apt-get update && apt-get -y install cron

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy genshin-cron file to the cron.d directory
COPY genshin-cron /etc/cron.d/genshin-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/genshin-cron

# Apply cron job
RUN crontab /etc/cron.d/genshin-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log