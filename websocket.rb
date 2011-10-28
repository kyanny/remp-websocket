require 'em-websocket'
require 'fileutils'
require 'optparse'

::Version = '0.0.1'

$stdout.sync = true

options = {}
opts = OptionParser.new

opts.on('-d', '--daemonize', 'Run daemonized in the background'){ 
  options['daemonize'] = true
}
opts.on('-a HOST', '--address HOST', 'bind to HOST address (default: 0.0.0.0)'){ |host|
  options['host'] = host
}
opts.on('-p PORT', '--port PORT', 'use PORT (default: 8080)'){ |port|
  options['port'] = port
}
  
opts.parse!
if options['daemonize']
  Process.daemon(true) # nochdir
  $0 = "em-websocket server (v#{::Version})"
end

FileUtils.mkdir_p(File.dirname(__FILE__) + "/tmp/pids")
pidfile = File.dirname(__FILE__) + "/tmp/pids/websocket.pid"
open(pidfile, "w"){ |f|
  f.puts $$
}

host = options['host'] || '0.0.0.0'
port = options['port'] || 8080

puts ">> Writing PID to tmp/pids/websocket.pid"
puts ">> em-websocket server (v#{::Version})"
puts ">> Listening on ws://#{host}:#{port}/"

connections = []

EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080, :debug => true) do |ws|
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
