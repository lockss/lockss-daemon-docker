#!/bin/sh

# Function to stop LOCKSS
sigterm_stop_lockss () {

   echo "Caught SIGTERM, stopping LOCKSS..."
   # Stop LOCKSS from a script
   /stop-lockss.sh

   echo "LOCKSS top complete.  Exiting"
   exit 0
}


# Set trap for SIGTERM which comes when docker stops the container
trap sigterm_stop_lockss SIGTERM

# Start the cron daemon
crond

# Start LOCKSS from a script
/start-lockss.sh

# sleep running in background runs indefinitely
# wait holds until sleep exit and is necessary to allow
# this docker-entry script to recieve SIGTERM from docker stop
sleep infinity &
wait
