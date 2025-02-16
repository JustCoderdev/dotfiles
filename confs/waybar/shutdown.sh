#!/usr/bin/env bash

# shutdown -k 1

# notification_message='The shutdown sequence has started'
# notification_body='The computer will shutdown in a minute. REMEMBER TO PUSH ALL UNCOMMITTED CHANGES!'
# notification_action=$(notify-send --action "R=Reboot" --urgency=critical "${notification_message}" "${notification_body}")
# notification_action=$(dunstify --action "mount,Mount drive as /mnt/..." --action "eject=Eject drive" "AAA")
 # --action "C=Cancel" --action "N=Shut now"
# echo "Action: ${notification_action}"




ACTION=$(dunstify --action="default,Reply" --action="forwardAction,Forward" "Message Received")

case "$ACTION" in
"default")
    echo reply_action
    ;;
"forwardAction")
    echo forward_action
    ;;
"2")
    echo handle_dismiss
    ;;
esac




exit 1


case $notification_action in
	"R") shutdown -r now ;;
	"C") shutdown -c ;;
    "N") shutdown now ;;
esac
