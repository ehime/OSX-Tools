#!/bin/bash
# Run Resin server without interation

# CPR : Jd Daniel :: Ehime-ken
# MOD : 2014-06-27 @ 13:56:46
# INP : $ connect|disconnect


###############################
###############################

function disconnect ()
{
    sudo killall -9 java netextender
    rPID=$(ps aux |grep 'run_resin' |grep -v grep|awk '{print$2}')
    [ ! -z "${rPID}" ] && {
      sudo kill -9 $rPID
    }

    sudo killall -HUP mDNSResponder

    ## kill mDNSResponder again
    rPID=$(ps aux |grep 'mDNS' |grep -v grep |awk '{print$2}')
    [ ! -z "${rPID}" ] && {
      sudo kill -9 $rPID
    }
}


function connect () 
{
  clear

  `disconnect` ## code reuse

  osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end

    tell application "Terminal"
      activate
      do script with command "
        cd $F_PATH

        netextender 72.175.244.2:4433   \
            --username=$F_USER          \
            --password=$F_PASS          \
            --domain=$F_DOMAIN          &

          sleep 3 ## waiting for extender to load

        bash start_apache.command       & 

          clear

        bash run_resin.command
       " in window 1
    end tell
EOF
}