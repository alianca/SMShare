require 'grid_io'

class ServeGridfsFiles

  def initialize(app)
    Mongo::GridIO.send(:include, SMShare::GridIO)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/grid\/(.+)$/
      process_request(env, $1)
    else
      @app.call(env)
    end
  end

  private
  def process_request(env, key)
    request = Rack::Request.new(env)
    begin
      Mongo::GridFileSystem.new(Mongoid.database).open(key, 'r') do |file|
        [200,
         { 'Content-Type' => file.content_type,
           'Content-Length' => file.file_length.to_s,
           #'Content-Disposition' => "attachment; filename=\"#{params[:filename] || file.filename}\""
         },
         file]
      end
    rescue
      file = open(File.expand_path(Rails.root + 'public/404.html'))
      [404, {'Content-Type' => 'html'}, file.read]
    end
  end

end
