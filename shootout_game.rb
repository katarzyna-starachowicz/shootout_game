class Game
  attr_reader :player_points, :server_points, :shoots
  attr_accessor :action

  def initialize
    @player_points = 0
    @server_points = 0
    @shoots = 0
    @xy_player = {}
    @xy_server = {}
    @action = nil
  end

  def xy_server
    {x: rand(5), y: rand(3)}
  end

  def goal?
    @xy_server != @xy_player
  end

  def player_point!
    @player_points += 1
  end

  def server_point!
    @server_points += 1
  end

  def add_points
    if @action == "shoot"
      player_point! if goal?
    else
      server_point! if goal?
    end
  end

  def kick!(message_body)
    @action = message_body[:action]
    @xy_player = {x: message_body[:x].to_i, y: message_body[:y].to_i}
    @xy_server = xy_server
    @shoots += 1
    add_points
  end

  def reverse_action
    @action = @action == "shoot" ? "save" : "shoot"
  end

  def end?
    if @shoots.even?
      if @player_points == 0 && @server_points == 3
        true
      elsif @player_points == 3 && @server_points == 0
        true
      elsif @player_points == 4 && @server_points <= 3
        true
      elsif @player_points <= 3 && @server_points == 4
        true
      elsif @shoots >= 10 && @player_points != @saver_points
        true
      end
    end
  end

  def over
    @action = "game over"
  end
end
