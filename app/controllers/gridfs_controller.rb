class GridfsController < ActionController::Metal
  def serve
    begin
      gridfs_path = request.env["PATH_INFO"].gsub("/grid/", "")
      gridfs_file = Mongo::GridFileSystem.new(Mongoid.database).open(gridfs_path, 'r')
      @response_body = gridfs_file.read
      @content_type = gridfs_file.content_type
    rescue
      @status = :file_not_found
      @content_type = 'text/plain'
      @response_body = ''
    end
  end
end
