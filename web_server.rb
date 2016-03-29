require 'socket'
require './messages'

server = TCPServer.new('localhost', 2050)
loop do
  socket = server.accept
  http = Message.new(socket)
  response = MyMessage.new.start_play
  socket.print "#{http.version} 200 OK\r\n" +
               "Content-Type: application/json\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response
  socket.close
end