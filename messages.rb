require 'json'

class Message
  def initialize(socket)
    @socket = socket
  end

  def method
    @socket.gets[/GET|POST/]
  end

  def version
    @socket.gets.split.last
  end

  def body
    body = @socket.recv(1000).split("\n").last if method == "POST"
    Hash[JSON.parse(body).map { |key, value| [key.to_sym, value] }] #symbolize keys
  end

  def ask_new_game?
    body[:hello] == "play a new game"
  end
end

class MyMessage
  def initialize
  end

  def start_play(action)
    {player_turn: action}.to_json
  end
end