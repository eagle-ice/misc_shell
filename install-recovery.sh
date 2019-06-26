#!/system/bin/sh
read n < /data/number
let "n = $n + 1"
echo -n "$n " > /data/number
logcat -v threadtime  > /data/log_$n.log
