require 'socket'
require './messages'
require './shootout_game'

server = TCPServer.new('localhost', 2050)
loop do
  socket = server.accept
  http = Message.new(socket)
  my_message = MyMessage.new
  response = if http.ask_new_game?
               random_action = rand(2).even? ? "shoot" : "save"
               @game = Game.new
               @game.action = random_action
               my_message.start_play(random_action)
             elsif http.still_play?
               if @game.action == http.action
                 @game.kick!(http.body)
                 @game.end? ? @game.over : @game.reverse_action
                 my_message.after_kick(@game)
               else
                 my_message.wrong_action
               end
             else
               my_message.wrong_message
             end
  socket.print "#{http.version} 200 OK\r\n" +
               "Content-Type: application/json\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response
  socket.close
end
