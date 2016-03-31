require 'socket'
require './messages'
require './shootout_game'

server = TCPServer.new('localhost', 2050)
loop do
  socket = server.accept
  client_message = ClientMessage.new(socket) # the whole message
  server_message = ServerMessage.new # will create only JSON body
  response = if client_message.ask_new_game?
               random_action = rand(2).even? ? "shoot" : "save"
               @game = Game.new
               @game.action = random_action
               server_message.start_play(random_action)
             elsif client_message.still_play?
               if @game.action == client_message.action
                 @game.kick!(client_message.body)
                 @game.end? ? @game.over : @game.reverse_action
                 server_message.after_kick(@game)
               else
                 server_message.wrong_action
               end
             else
               server_message.wrong_message
             end
  socket.print "#{client_message.version} 200 OK\r\n" +
               "Content-Type: application/json\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response
  socket.close
end
