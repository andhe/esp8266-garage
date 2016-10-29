function setupNetworkServices()
   -- register zeroconf service name
  mdns.register("garage", { description="Garage Door Opener", service="http", port=80, location='Garage' })

   -- only one tcp server is allowed to be opened at any time,
   -- so close to support (re)starting this script multiple times.
  if srv ~= nil
  then
    srv:close()
  end

   -- set up webserver
  srv=net.createServer(net.TCP)
  srv:listen(80, handleClient)
end

