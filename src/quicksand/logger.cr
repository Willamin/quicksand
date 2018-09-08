class Quicksand::Logger
  enum Level
    Forced
    Normal
    Verbose
    Debug
  end

  property allowed : Level

  def initialize(@allowed = Level::Normal); end

  # Normal output

  def force(thing)
    STDOUT.print(thing)
  end

  def print(thing)
    if allowed >= Level::Normal
      STDOUT.print(thing)
    end
  end

  def verbose(thing)
    if allowed >= Level::Verbose
      STDOUT.print(thing)
    end
  end

  def debug(thing)
    if allowed >= Level::Debug
      STDOUT.print(thing)
    end
  end

  # New lines

  def force
    STDOUT.puts
  end

  def puts
    if allowed >= Level::Normal
      STDOUT.puts
    end
  end

  def verbose
    if allowed >= Level::Verbose
      STDOUT.puts
    end
  end

  def debug
    if allowed >= Level::Debug
      STDOUT.puts
    end
  end

  # Error output

  def err(thing = "")
    if allowed >= Level::Normal
      STDERR.puts(thing)
    end
  end

  def force_err(thing = "")
    STDERR.puts(thing)
  end

  # Adjusters

  def quiet!
    @allowed = Level::Forced
  end

  def verbose!
    @allowed = Level::Verbose
  end

  def debug!
    @allowed = Level::Debug
  end

  # Promotion to top level

  macro promote!(logger)
    def force(thing)
      {{logger}}.force(thing)
    end

    def force
      {{logger}}.force
    end

    def print(thing)
      {{logger}}.print(thing)
    end

    def puts
      {{logger}}.puts
    end
  end
end
