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

      ngrok.ngrok_url_https.try do |https_url|
        print "remote https : "
        print "#{https_url}/#{c.filename}"
        puts
        puts

        URI.parse(https_url).try do |uri|
          uri.host.try do |host|
            ngrok_subdomain = host.split(".")[-3]

            print "labeled      : "
            force "https://sand.wfl.space/#{ngrok_subdomain}"
            force
            puts
          end
        end
      end

      server.listen
    end
  rescue e
    if pipe
      pipe.puts("[bad]#{e.message}")
    else
      raise e
    end
  end
end
