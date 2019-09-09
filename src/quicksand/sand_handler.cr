class Quicksand::SandHandler
  include HTTP::Handler

  getter file_path : String
  getter mod_time : Time
  getter file_size : UInt64
  getter max_downloads : Int32
  getter download_count : Int32

  def initialize(@file_path : String, @max_downloads)
    @mod_time = File.info(file_path).modification_time
    @file_size = File.size(file_path)
    @download_count = 0
  end

  def call(context)
    if we_should_die
      context.response.status_code = 404
      return
    end

    case context.request.path
    when "/"
      context.response.status_code = 302
      context.response.headers["Location"] = "/" + file_path
    when file_path
      context.response.headers["Etag"] = %{W/"#{mod_time.to_unix}"} if mod_time
      context.response.headers["Last-Modified"] = HTTP.format_time(mod_time)
      context.response.content_length = file_size
      File.open(file_path) do |file|
        IO.copy(file, context.response)
      end
      @download_count += 1

      spawn do
        if we_should_die
          err "Max downloads (#{download_count}/#{max_downloads}) reached"
          exit 1
        end
      end
    else
      context.response.status_code = 404
    end
  end

  def we_should_die
    max_downloads > 0 && download_count >= max_downloads
  end
end
