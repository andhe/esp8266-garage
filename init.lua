inittimer=0
initdelay=10000 -- 10 sec to abort via "tmr.stop(0)"
initfile="garage.lua"
tmr.alarm(inittimer, initdelay, tmr.ALARM_SINGLE,
          function() dofile(initfile) end)
