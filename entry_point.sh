#!/bin/bash

#source /opt/bin/functions.sh

export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

rm -f /tmp/.X*lock


# phantomjs will want to put its log file somewhere it can write to
xvfb-run -a --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" \
  java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
  ${SE_OPTS} &
NODE_PID=$!

trap shutdown SIGTERM SIGINT
wait $NODE_PID
