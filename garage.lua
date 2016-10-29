 -- config settings
ssid="your-wlan-name"
wlanpass="your-wlan-password"

pin=9      -- gpio pin connected to relay (9 = RX, 4 = GPIO2)
timer=1    -- timer id (0-6)
delay=1000 -- timer delay in ms between press and release of door button

 -- init gpio/timer handling
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.LOW)

 -- setup wifi
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
  print("\n\tSTA - CONNECTED"..
        "\n\tSSID: "..T.SSID..
        "\n\tBSSID: "..T.BSSID..
        "\n\tChannel: "..T.channel)
end)

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
  print("\n\tSTA - GOT_IP"..
        "\n\tIP: "..T.IP.."/"..T.netmask..
        "\n\tGW: "..T.gateway)
  setupNetworkServices()
end)

wifi.setmode(wifi.STATION)
wifi.sta.config(ssid, wlanpass)

dofile("garage-door.lua")

dofile("garage-web.lua")

dofile("garage-net.lua")
