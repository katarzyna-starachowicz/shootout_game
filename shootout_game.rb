class Game
  attr_reader :player_points, :server_points
  attr_accessor :action

  def initialize
    @player_points = 0
    @server_points = 0
    @shoots = 0
    @action = nil
  end

  def player_point!
    @player_points += 1
  end

  def server_point!
    @server_points += 1
  end
end