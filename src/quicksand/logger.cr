class Quicksand::Logger
  enum Level
    AbsolutelySilent
    Forced
    Normal
    Verbose
  end

  property allowed : Level

  def initialize(@allowed = Level::Normal); end

  # Normal output

  def force(thing)
    if allowed >= Level::Forced
      STDOUT.print(thing)
    end
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

  # New lines

  def force
    if allowed >= Level::Forced
      STDOUT.puts
    end
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

  # Error output

  def err(thing = "")
    if allowed >= Level::Normal
      STDERR.puts(thing)
    end
  end

  def force_err(thing = "")
    if allowed >= Level::Forced
      STDERR.puts(thing)
    end
  end

  # Adjusters

  def quiet!
    @allowed = Level::Forced
  end

  def verbose!
    @allowed = Level::Verbose
  end

  def daemonize!
    @allowed = Level::AbsolutelySilent
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

    def err(thing)
      {{logger}}.err(thing)
    end

    def force_err(thing)
      {{logger}}.force_err(thing)
    end
  end
end
