struct Quicksand::Config
  property filename : String?
  property host : String = ENV["SANDHOST"]? || ENV["HOST"]? || "127.0.0.1"
  property port : Int32 = ENV["SANDPORT"]?.try(&.to_i) || ENV["PORT"]?.try(&.to_i) || 7000

  def verify!
    raise "Must provide a filename" if filename.nil?
    raise "#{filename} does not exist" unless File.exists?(filename.not_nil!)
  rescue e
    puts e.message
    exit 1
  end

  def self.from_cli
    c = Config.new
    c.filename = ARGV[0]?
    Frozen.new(c)
  end

  struct Frozen
    getter filename : String
    getter host : String
    getter port : Int32

    def initialize(@filename, @host, @port); end

    def initialize(c : Config)
      c.verify!
      @filename = c.filename.not_nil!
      @host = c.host
      @port = c.port
    end
  end
end
