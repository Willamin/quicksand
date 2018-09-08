class Quicksand::App
  def self.main(c : Quicksand::Config, pipe : IO? = nil)
    server = HTTP::Server.new([
      HTTP::ErrorHandler.new,
      # HTTP::LogHandler.new,
      HTTP::CompressHandler.new,
      Quicksand::SandHandler.new(c.filename, c.max_downloads),
    ])

    if c.show_banner
      print(Quicksand::BANNER)
      puts
    end

    print("spinning up ngrok...........")
    Ngrok.start({addr: "#{c.host}:#{c.port}"}) do |ngrok|
      print("done")
      puts

      if pipe
        pipe.puts "#{ngrok.ngrok_url_https}/#{c.filename}"
      end

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
  end
end
