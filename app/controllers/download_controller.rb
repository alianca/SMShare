class DownloadController < ActionController::Metal
  def index
    begin
      user_file = UserFile.find(params[:id])
      self.content_type = user_file.filetype
      headers["Content-Disposition"] = "attachment; filename=\"#{user_file.filename}\""
      self.response_body = user_file.file.file.read
    rescue Mongoid::Errors::DocumentNotFound
      self.status = 404 #:file_not_found
      self.content_type = 'text/html'
      self.response_body = open(File.expand_path(Rails.root + 'public/404.html')).read
    end
  end
end
