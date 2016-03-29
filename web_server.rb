require 'socket'
require './messages'
require './shootout_game'

server = TCPServer.new('localhost', 2050)
loop do
  socket = server.accept
  http = Message.new(socket)
    response = if http.ask_new_game?
                 random_action = rand(2).even? ? "shoot" : "save"
                 my_message = MyMessage.new
                 game = Game.new
                 game.action = random_action
                 my_message.start_play(random_action)
               elsif http.still_play?
                 if game.action == http.action
                   game.kick!(http.body)
                   game.reverse_action
                   game.end? ? my_message.game_end(game) : my_message.still_play(game)
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
