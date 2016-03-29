require 'socket'

server = TCPServer.new('localhost', 2050)
loop do
  socket = server.accept
  response = "Hello World!"
  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: application/json\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response
  socket.close
end