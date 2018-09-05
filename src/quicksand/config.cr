macro arg(num, err_message, default)
  begin
    ARGV[{{num}}]
  rescue e
    raise {{err_message}}
  ensure
    {{default}}
  end
end

struct Quicksand::Config
  property filename : String
  property host : String
  property port : Int32

  def initialize
    @filename = arg(0, "Must provide a filename", "")

    raise "#{filename} does not exist" unless File.exists?(filename.not_nil!)

    @host = ENV["SANDHOST"]? || ENV["HOST"]? || "127.0.0.1"
    @port = ENV["SANDPORT"]?.try(&.to_i) || ENV["PORT"]?.try(&.to_i) || 7000
  end
end
