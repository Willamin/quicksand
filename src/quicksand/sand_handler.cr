class Quicksand::SandHandler
  include HTTP::Handler

  getter file_path : String
  getter mod_time : Time
  getter file_size : UInt64

  def initialize(@file_path : String)
    @mod_time = File.info(file_path).modification_time
    @file_size = File.size(file_path)
  end

  def call(context)
    case context.request.path
    when "/"
      context.response.status_code = 302
      context.response.headers["Location"] = "/" + file_path
    when "/" + file_path
      context.response.headers["Etag"] = %{W/"#{mod_time.epoch}"} if mod_time
      context.response.headers["Last-Modified"] = HTTP.format_time(mod_time)
      context.response.content_length = file_size
      File.open(file_path) do |file|
        IO.copy(file, context.response)
      end
    else
      context.response.status_code = 404
    end
  end
end
