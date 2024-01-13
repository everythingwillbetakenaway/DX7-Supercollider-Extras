#!/bin/bash


if pgrep "qjackctl" > /dev/null
then
    echo "Jack is already running. Is it using the correct patchbay?"
else
    qjackctl -s -a qjackctl/mosca1st_and_2nd.xml&
    sleep 5
fi

//killall -9 sclang
//killall -9 scsynth
sleep 2
#sclang chowning117.scd&

sleep 2

jack_disconnect SuperCollider:out_3 system:playback_3 
jack_disconnect SuperCollider:out_4 system:playback_4 
jack_disconnect SuperCollider:out_5 system:playback_5 
jack_disconnect SuperCollider:out_6 system:playback_6 
jack_disconnect SuperCollider:out_7 system:playback_7 
jack_disconnect SuperCollider:out_8 system:playback_8 
jack_disconnect SuperCollider:out_9 system:playback_9 
jack_disconnect SuperCollider:out_10 system:playback_10 
jack_disconnect SuperCollider:out_11 system:playback_11
jack_disconnect SuperCollider:out_12 system:playback_12
jack_disconnect SuperCollider:out_13 system:playback_13
jack_disconnect SuperCollider:out_14 system:playback_14
jack_disconnect SuperCollider:out_15 system:playback_15

jack_disconnect system:capture_1 SuperCollider:in_1 
jack_disconnect system:capture_2 SuperCollider:in_2 
jack_disconnect system:capture_3 SuperCollider:in_3 
jack_disconnect system:capture_4 SuperCollider:in_4 
jack_disconnect system:capture_5 SuperCollider:in_5 
jack_disconnect system:capture_6 SuperCollider:in_6 
jack_disconnect system:capture_7 SuperCollider:in_7 
jack_disconnect system:capture_8 SuperCollider:in_8 
jack_disconnect system:capture_9 SuperCollider:in_9 
jack_disconnect system:capture_10 SuperCollider:in_10 
jack_disconnect system:capture_11 SuperCollider:in_11 
jack_disconnect system:capture_12 SuperCollider:in_12
jack_disconnect system:capture_13 SuperCollider:in_13 
jack_disconnect system:capture_14 SuperCollider:in_14 
jack_disconnect system:capture_15 SuperCollider:in_15 
jack_disconnect system:capture_16 SuperCollider:in_16 
jack_disconnect system:capture_17 SuperCollider:in_17 
jack_disconnect system:capture_18 SuperCollider:in_18 


killall -9 ambdec 
ambdec -V -30 -c ambdec/octagon-2h0v_iain.ambdec&
sleep 1
ambdec -V -30 -c ambdec/octagon-1h0v_iain.ambdec&

