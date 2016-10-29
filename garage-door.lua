 -- helper function to activate the door button for a short while
function pressDoorOpener()
  gpio.write(pin, gpio.HIGH)

  tmr.alarm(timer, delay, tmr.ALARM_SINGLE,
            function() gpio.write(pin, gpio.LOW) end)
end


