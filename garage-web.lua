 -- helper function to handle webserver connections
function handleClient(conn)
  conn:on("receive", function(sck, req)
    local resp = {"HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n"}

     -- find requested path, used method and arguments
    local _, _, method, path, vars = string.find(req, "([A-Z]+) (.+)?(.+) HTTP");
    if(method == nil)then
      _, _, method, path = string.find(req, "([A-Z]+) (.+) HTTP");
    end

    local reqarg = {}
    if (vars ~= nil)then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        reqarg[k] = v
      end
    end

     -- handle request arguments
    if reqarg.pushbutton ~= nil
    then
      pressDoorOpener()
       -- redirect to avoid repost on reload
      resp = {"HTTP/1.0 303 See Other\r\nLocation: "..path.."\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n"}
    else

     -- construct response body
    resp[#resp + 1] = "<html><head><title>Garage door</title></head>"
    resp[#resp + 1] = "<body><p>Current pin state: "

    if gpio.read(pin) == gpio.HIGH
    then
      resp[#resp] = resp[#resp].."HIGH</p>"
    else
      resp[#resp] = resp[#resp].."LOW</p>"
    end

    local timerrunning, timermode = tmr.state(timer)
    if timerrunning
    then
      resp[#resp+1] = "<p>Timer is currently running.</p>"
    end

    resp[#resp+1] = '<p><a href="?pushbutton=1"><button>Door Opener</button></a>'

    resp[#resp + 1] = "</body></html>"

    end

     -- sends and removes the first element from the 'resp' table
    local function send(sk)
      if #resp > 0
      then
        sk:send(table.remove(resp, 1))
      else
        sk:close()
        resp = nil
      end
    end

    -- triggers the send() function again once the first chunk of data was sent
    sck:on("sent", send)

    send(sck)
  end)
end


