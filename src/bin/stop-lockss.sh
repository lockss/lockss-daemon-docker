#!/bin/sh

. /etc/init.d/functions
. /etc/profile
. /etc/lockss/functions

stop_lockss () {
    echo -n "Stopping ${1}: "
    echo "Stopping LOCKSS for user ${1} at `date`" >> ${LOG_FILE}
    rm -f "${KEEP_GOING}"
    killproc ${1}

    count=0
    while [ -e ${LOCKFILE} -a $count -lt 15 ] ; do
        sleep 1
        count=`expr $count + 1`
    done

    rm -f ${PID_FILE}
    # tk - should kill ssl proc, del ssl  passwd file and pid file
    echo
}
set_lockss_user
for A in ${LOCKSS_USER}
do
        set_variables ${A}
        stop_lockss ${A}
        unset_variables
done


exit 0
