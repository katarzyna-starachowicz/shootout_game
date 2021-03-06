require 'minitest/autorun'
require './shootout_game'

class ShootoutGameTest < Minitest::Test
  def setup
    @game = Game.new
  end

  def test_initialization
    assert_equal 0, @game.player_points
    assert_equal 0, @game.server_points
    assert_equal nil, @game.action
    assert_instance_of Game, @game
  end

  def test_player_pointing
    3.times { @game.player_point! }
    assert_equal 3, @game.player_points
    assert_equal 0, @game.server_points
  end

  def test_server_pointing
    5.times { @game.server_point! }
    assert_equal 5, @game.server_points
    assert_equal 0, @game.player_points
  end

  def test_shooting_player_win
    @game.stub(:rand, 0) do
      @game.kick!({ hello: "play", action:"shoot", x:"1", y:"2" })
      assert_equal 1, @game.shoots
      assert_equal 0, @game.server_points
      assert_equal 1, @game.player_points
    end
  end

  def test_shooting_player_lost
    @game.stub(:rand, 0) do
      @game.kick!({ hello: "play", action:"shoot", x:"0", y:"0" })
      assert_equal 1, @game.shoots
      assert_equal 0, @game.server_points
      assert_equal 0, @game.player_points
    end
  end

  def test_saving_player_win
    @game.stub(:rand, 0) do
      @game.kick!({ hello: "play", action:"save", x:"0", y:"0" })
      assert_equal 1, @game.shoots
      assert_equal 0, @game.server_points
      assert_equal 0, @game.player_points
    end
  end

  def test_saving_player_lost
    @game.stub(:rand, 0) do
      @game.kick!({ hello: "play", action:"save", x:"2", y:"2" })
      assert_equal 1, @game.shoots
      assert_equal 1, @game.server_points
      assert_equal 0, @game.player_points
    end
  end

  def test_reversing_action
    @game.action = "shoot"
    @game.reverse_action
    assert_equal "save", @game.action

    @game.reverse_action
    assert_equal "shoot", @game.action
  end

  def test_game_ending_true
    @game.stub(:rand, 0) do
      3.times { @game.kick!({hello: "play", action: "shoot", x: "1", y: "2"}) }
      3.times { @game.kick!({hello: "play", action: "save", x: "0", y: "0"}) }
      assert @game.end?
    end
  end

  def test_game_ending_false
    @game.stub(:rand, 0) do
      2.times { @game.kick!({hello: "play", action: "shoot", x: "1", y: "2"}) }
      3.times { @game.kick!({hello: "play", action: "save", x: "0", y: "0"}) }
      assert !@game.end?
    end
  end

  def test_game_over
    @game.over
    assert_equal "game over", @game.action
  end
end
