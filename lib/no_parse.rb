class NoParse
  def initialize(app, options={})
    @app = app
    @urls = options[:urls]
  end

  def call(env)
    env['CONTENT_TYPE'] = 'text/plain' if @urls.include? env['PATH_INFO']
    @app.call(env)
  end
end
