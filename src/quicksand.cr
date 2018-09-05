require "http/server"
require "ngrok"
require "./quicksand/*"

module Quicksand
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

begin
  c = Quicksand::Config.new
rescue e
  STDERR.puts e.message
  exit 1
end

server = HTTP::Server.new([
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new,
  HTTP::CompressHandler.new,
  Quicksand::SandHandler.new(c.filename),
])

print "spinning up ngrok..."

Ngrok.start({addr: "#{c.host}:#{c.port}"}) do |ngrok|
  puts "done"

  print "spinning up static server"
  server.bind_tcp(c.host, c.port)
  puts "done"

  puts

  puts "local        : http://#{c.host}:#{c.port}/#{c.filename}"
  puts "remote http  : #{ngrok.ngrok_url}/#{c.filename}"
  puts "remote https : #{ngrok.ngrok_url_https}/#{c.filename}"
  server.listen
end
