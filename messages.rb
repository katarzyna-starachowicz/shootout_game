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

  def still_play?
    body[:hello] == "play" && !!/\A(shoot|save)\z/.match(body[:action]) && !!/\A(0|1|2|3|4)\z/.match(body[:x]) && !!/\A(0|1|2)\z/.match(body[:y])
  end

  def action
    body[:action]
  end
end

class MyMessage
  def initialize
  end

  def start_play(action)
    {player_turn: action}.to_json
  end

  def still_play(game)
    {
      player_turn: game.action,
      player_points: game.player_points,
      server_points: game.server_points,
      shoots_together: game.shoots
    }.to_json
  end

  def game_end(game)
    {
      player_turn: "end",
      player_points: game.player_points,
      server_points: game.server_points,
      shoots_together: game.shoots
    }.to_json
  end

  def wrong_action
    {mistake: "wrong action"}.to_json
  end

  def wrong_message
    {mistake: "wrong message"}.to_json
  end
end
