def arg(num, err_message, default)
  begin
    ARGV[num]
  rescue e
    raise err_message
  ensure
    default
  end
end

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

def env(name : String, default)
  x = ENV[name]?
  if x.nil?
    default
  else
    x
  end
end

struct Quicksand::Config
  property filename : String
  property host : String
  property port : Int32
  property max_downloads : Int32
  property show_banner : Bool

  def initialize
    @filename = arg(0, "Must provide a filename", "")

    raise "#{filename} does not exist" unless File.exists?(filename.not_nil!)

    @host = env("HOST", "127.0.0.1")
    @port = env("PORT", "7000").to_i
    @max_downloads = env("SAND_MAX", "1").to_i
    @show_banner = env("SAND_BANNER", "true").to_b
  end
end
