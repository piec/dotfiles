ret=$(synclient -l | grep TouchpadOff | grep -o "[01]")
if [ x"$ret" = x"1" ]; then
    synclient TouchpadOff=0
else
    synclient TouchpadOff=1
fi

