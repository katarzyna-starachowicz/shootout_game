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
end

class MyMessage
  def initialize
  end

  def start_play
    {welcome: "Let's play!"}.to_json
  end
end