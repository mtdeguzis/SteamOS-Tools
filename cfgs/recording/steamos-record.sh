#! /bin/bash

# ask user for some vars
echo -e "\nFPS to record in? (30/60)"
read -erp "Choice: " FPS

echo -e "\nPrefix for recording? (ENTER for default)"
read -erp "Choice: " NAME_CUSTOM

# ensure pulse is gone
rm -f /tmp/pulse.wav

#set variables
RECORDER="avconv"
DIR="$HOME/Videos"
FRAMERATE="$FPS"
FORMAT="avi"
LOG="/tmp/dumps/${RECORDER}-recording.log"
export DISPLAY=:0.0

# Set NAME
if [[ "$NAME_CUSTOM" == "" ]]; then

        # set to default
        STARTNAME="recording"

else

        # set to choice
        STARTNAME="$NAME_CUSTOM"

fi

# log errors
exec | tee ${LOG}

# if a recording is already running, kill it and stop the script
if [[ ! -z $(ps aux|awk '{print $11}'|grep ${RECORDER}) ]]; then

        killall ${RECORDER}
        echo "${RECORDER} closed by recording-start.sh."2>>${LOG}
        exit 0

fi

#grab resolution
RES=$(xdpyinfo|grep dimensions|awk '{print $2}')

# make recording directories if they don't exist yet
if [[ ! -d ${DIR} ]]; then

        mkdir -p ${DIR}

fi

# set name of the recording
DATE=$(date +"_%Y%m%d")
NUMBER=1
while [ -f $DIR/${STARTNAME}-${NUMBER}${DATE}.$FORMAT ]
do
        NUMBER=$((${NUMBER}+1))
done
NAME=${STARTNAME}-${NUMBER}${DATE}

# start the recording
${RECORDER} -f pulse -i default /tmp/pulse.wav -f x11grab -r ${FRAMERATE} -s ${RES} -i ${DISPLAY} -acodec pcm_s16le -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ${DIR}/${NAME}.avi

# In case the recording does finish/crash
rm /tmp/pulse.wav
