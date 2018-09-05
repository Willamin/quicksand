require "http/server"
require "ngrok"
require "./quicksand/*"

module Quicksand
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

c = Quicksand::Config.from_cli

server = HTTP::Server.new([
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new,
  HTTP::CompressHandler.new,
  Quicksand::SandHandler.new(c.filename),
])

puts "starting..."
Ngrok.start({addr: "#{c.host}:#{c.port}"}) do |ngrok|
  server.bind_tcp(c.host, c.port)
  puts "listening at http://#{c.host}:#{c.port}"
  puts "http:        #{ngrok.ngrok_url}"
  puts "https:       #{ngrok.ngrok_url_https}"
  server.listen
end
