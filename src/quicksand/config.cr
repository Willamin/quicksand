macro arg(num, err_message, default)
  begin
    ARGV[{{num}}]
  rescue e
    raise {{err_message}}
  ensure
    {{default}}
  end
end

macro env_int(name)
  ENV[{{name}}]?.try(&.to_i)
end

struct Quicksand::Config
  property filename : String
  property host : String
  property port : Int32
  property max_downloads : Int32

  def initialize
    @filename = arg(0, "Must provide a filename", "")

    raise "#{filename} does not exist" unless File.exists?(filename.not_nil!)

    @host = ENV["SANDHOST"]? || ENV["HOST"]? || "127.0.0.1"
    @port = env_int("SANDPORT") || env_int("PORT") || 7000
    @max_downloads = env_int("SAND_MAX") || 0
  end
end
