require "http/server"
require "ngrok"
require "./quicksand/*"

module Quicksand
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

MAIN_LOGGER = Quicksand::Logger.new
Quicksand::Logger.promote!(MAIN_LOGGER)

begin
  c = Quicksand::Config.new

  MAIN_LOGGER.quiet! if c.quiet
  MAIN_LOGGER.verbose! if c.verbose
  MAIN_LOGGER.debug! if c.debug

  server = HTTP::Server.new([
    HTTP::ErrorHandler.new,
    HTTP::LogHandler.new,
    HTTP::CompressHandler.new,
    Quicksand::SandHandler.new(c.filename, c.max_downloads),
  ])

  if c.show_banner
    print(Quicksand::BANNER)
    puts
  end

  print("spinning up ngrok...")
  Ngrok.start({addr: "#{c.host}:#{c.port}"}) do |ngrok|
    print("done")
    puts

    print("spinning up static server...")
    server.bind_tcp(c.host, c.port)
    print("done")
    puts

    print "limiting to #{c.max_downloads} downloads"
    puts

    print "local        : "
    print "http://#{c.host}:#{c.port}/#{c.filename}"
    puts

    print "remote http  : "
    print "#{ngrok.ngrok_url}/#{c.filename}"
    puts

    print "remote https : "
    force "#{ngrok.ngrok_url_https}/#{c.filename}"
    force
    puts

    server.listen
  end
rescue e
  STDERR.puts e.message
  exit 1
end
