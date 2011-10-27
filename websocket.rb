require 'em-websocket'

connections = []

EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080, :debug => true) do |ws|
  puts "start server at ws://localhost:8080/"
  
  ws.onopen { 
    unless connections.include?(ws)
      connections << ws
    end
  }
  
  ws.onmessage { |msg|
    connections.each do |conn|
      msg.force_encoding('UTF-8') if msg.respond_to?(:force_encoding)
      if conn != ws # sender != receiver
        #msg += "ssssssssssssss"
        conn.send msg
      else
        conn.send msg
      end
    end
  }
  
  ws.onclose { 
    connections.delete(ws)
  }
end
