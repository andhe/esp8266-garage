# A simple esp-01 (esp8266) project on top of NodeMCU

## Background

A simple garage door opener project based on the super-creap wifi hardware
called esp8266 aka. nodemcu.

## Required components

 * esp-01 (or better)
 * nodemcu-firmware built with mdns enabled (or comment out the mdns line
   in garage-net.lua), on top of the standard net, gpio, timer modules.
   https://nodemcu-build.com/
 * An "arduino relay board".
 * A 3v3 (plus 5v) power supply.
 * 3v3 ttl to (usb) serial adapter (during development).
 * Breadboard wires.

## Initial wiring

Hint:
To simplify the wiring I soldered a 10kOhm resistor between the VCC and CH_PD
pins. Both needs 3v3. This way I only need to connect VCC.

First connect your power supply cables for GND and VCC/CH_PD.

Connect your TTL adapter GND, RX, TX.

Connect "GPIO0" pin via 10kOhm resistor to GND.

Connect your power supply to outlet.

You're now ready to start flashing the firmware. Don't forget to remove
"GPIO0" pull-down to GND (which you can do as soon as your board has
booted).

## Flashing the nodemcu-firmware
 * Reflash by pulling "GPIO0" (via 10kOhm resistor) to ground while booting
   and then use eg. esptool to flash the just downloaded nodemcu firmware.

 Example:
```
 esptool -cp /dev/ttyUSB0 -cf ~/Downloads/nodemcu-master-9-modules-2016-10-28-12-00-50-integer.bin
```

The board should automatically reboot after flashing and if you open
a serial terminal program (eg. putty) on /dev/ttyUSB0 you should now
see a nodemcu prompt. Cut power and reboot the board again if you want
the full output showing the initial information (like which modules
your build has available).


## Uploading the garage lua code

First edit `garage.lua` and set your wifi name/password at the top of the
file, also do other modifications/deviations while at it.

Easiest way to upload is by using a tool to help you write the files
line by line over the serial port. Try eg. https://github.com/4refr0nt/luatool

Example:

```
for file in garage.lua garage-door.lua garage-net.lua garage-web.lua init.lua
do
  ./luatool/luatool/luatool -b 115200 -f $file -t $file -v
done
```

Make sure each file gets successfully uploaded.

## Final wiring

### Using gpio pins on esp-01

Please none that on the `esp-01` there are two pins marked as gpios, "GPIO0"
and "GPIO2". Neither of these are easy to use as they both affect the
bootup of the esp itself. They need to be pulled high during boot for
flash booting. If either one is pulled low your esp will not boot from
flash. For wiring suggestions see:
http://www.forward.com.au/pfod/ESP8266/GPIOpins/index.html

If you like me are lazy and you only need a single output pin you can
more easily just reuse the RX pin on the esp as a regular gpio.
On the esp-01 the RX is pin 9 (TX = 10, GPIO0 = 2, GPIO2 = 4).
(The relay board signal pins pulls down in my case.)

This means you can't use a TTL adapter at the same time as running
the lua code.

But what if I need to fix something? The init.lua script delays running
the garage code 10 seconds, to allow for breaking in.
If you need to use the TTL adapter after loading the garage code, then
make sure to type `tmr.stop(0)` at the prompt directly after it shows
up (after poweron). This stops the timer and thus aborts starting
the garage code.

### Hooking up the relay board

An arduino works with 5v rather than 3v3. Usually using 3v3 should work
but I also had 5v available in my power supply so I connected VCC on
the relay board to 5v. Also connect GND to power supply.
Then connected RX pin on esp-01 to the data pin on the relay board (after
removing the ttl adapter).


## Web interface

You should now be able to control the relay via the web interface on
the module. Unless you disabled mdns, you should be able to access
it via:
http://garage.local/

(If your web browser host does not support mdns/bonjour/zeroconf lookups
you'll need to figure out the ip address the esp node got assigned on
your LAN.)

Push the button to trigger the relay to open for 1 second (or whatever
delay you configured).

Note: the web interface is very simple so won't automatically refresh
      when state changes. You need to manually reload the page to get
      fresh information.

## License

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

The above statement does not cover any included or linked documentation
(except this README.md).

