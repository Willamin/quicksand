require "http/server"
require "ngrok"

module Quicksand
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

unless ARGV[0]?
  puts "Must provide a filename as arg0"
  exit 1
end

unless File.exists?(ARGV[0])
  puts "#{ARGV[0]} does not exist"
  exit 1
end

server = HTTP::Server.new([
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new,
  HTTP::CompressHandler.new,
]) do |context|
  case context.request.path
  when "/"
    context.response.status_code = 302
    context.response.headers["Location"] = "/" + ARGV[0]
  when "/" + ARGV[0]
    context.response.headers["Etag"] = %{W/"#{File.info(ARGV[0]).modification_time.epoch}"}
    context.response.headers["Last-Modified"] = HTTP.format_time(File.info(ARGV[0]).modification_time)
    context.response.content_length = File.size(ARGV[0])
    File.open(ARGV[0]) do |file|
      IO.copy(file, context.response)
    end
  else
    context.response.status_code = 404
  end
end

HOST = "127.0.0.1"
PORT = 7000

puts "starting..."
Ngrok.start({addr: "#{HOST}:#{PORT}"}) do |ngrok|
  server.bind_tcp(HOST, PORT)
  puts "listening at http://#{HOST}:#{PORT}"
  puts "http: #{ngrok.ngrok_url}"
  server.listen
end
