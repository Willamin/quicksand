require "option_parser"

class String
  def to_b
    case self.downcase
    when "yes", "y", "1", "true"
      true
    when "no", "n", "0", "false"
      false
    else
      raise "Invalid boolean conversion"
    end
  end
end

struct Quicksand::Config
  getter quiet : Bool
  getter verbose : Bool
  getter filename : String
  getter host : String
  getter port : Int32
  getter max_downloads : Int32
  getter show_banner : Bool
  getter daemonize : Bool

  def initialize
    quiet = false
    verbose = false
    host = "127.0.0.1"
    port = 7000
    max_downloads = 1
    show_banner = true
    filename = ""
    daemonize = false

    if ENV["HOST"]?
      host = ENV["HOST"]
    end

    if ENV["PORT"]?.try(&.to_i?)
      port = ENV["PORT"].to_i
    end

    if ENV["SAND_MAX"]?.try(&.to_i?)
      max_downloads = ENV["SAND_MAX"].to_i
    end

    if ENV["SAND_BANNER"]?.try(&.to_b)
      show_banner = ENV["SAND_BANNER"].to_b
    end

    OptionParser.parse! do |parser|
      parser.banner = "Usage: quicksand [arguments]"
      parser.on("-h HOST", "--host=HOST", "specify the host to use") { |h| host = h }
      parser.on("-p PORT", "--port=PORT", "specify the port to use") { |p| port = p.to_i }
      parser.on("-m MAX", "--max=MAX", "specify the maximum number of downloads allowed (anything less than 0 is unlimited)") { |m| max_downloads = m.to_i }
      parser.on("-d", "--daemon", "run as a daemon") { daemonize = true; quiet = true }
      parser.separator
      parser.on("-q", "--quiet", "suppress output (implies -B, but can be overridden with -b)") { quiet = true; show_banner = false }
      parser.on("-v", "--verbose", "outputs verbosely (disables -q)") { quiet = false; verbose = true }
      parser.on("-b", "--banner", "display the banner") { show_banner = true }
      parser.on("-B", "--no-banner", "hide the banner") { show_banner = false }
      parser.separator
      parser.on("--help", "show this help") { puts parser; exit 0 }
      parser.on("--version", "show the version") { puts "quicksand v#{Quicksand::VERSION}"; exit 0 }

      parser.unknown_args do |args|
        unless args.empty?
          filename = args.first
        end
      end
    end

    if filename.empty?
      raise "Must provide a filename"
    end

    raise "#{filename} does not exist" unless File.exists?(filename)

    @quiet = quiet
    @verbose = verbose
    @filename = filename
    @host = host
    @port = port
    @max_downloads = max_downloads
    @show_banner = show_banner
    @daemonize = daemonize
  end
end
