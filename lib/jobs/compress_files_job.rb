require 'zipruby'
require 'lib/file_name'

class Jobs::CompressFilesJob < Resque::JobWithStatus
  @queue = :compress

  def perform
    param = JSON.parse(options["parameter"])
    param["files"].delete_if { |f| f.blank? }

    files = UserFile.where(:_id.in => (param["files"].collect { |id| BSON::ObjectId(id) }))
    folders = Folder.where(:_id.in => (param["files"].collect { |id| BSON::ObjectId(id) }))
    current_dir = Folder.find(options["folder_id"]["$oid"])
    user = User.find(options["user_id"]["$oid"])

    @num = 1
    @total = files.count
    zip_name = FileName.sanitize(param["filename"])
    zip_name += '.zip' unless zip_name =~ /.*\.zip$/
    zip_file = Tempfile.new zip_name
    Zip::Archive.open(zip_file.path, Zip::CREATE, Zip::BEST_SPEED) do |zip|
      files.each do |file|
        zip.add_buffer(file.alias, file.file.file.read)
        at(@num, @total, "Compactando arquivo #{@num} de #{@total}: ./#{file.alias}")
        @num += 1
      end
      folders.each { |folder| compress_recursively zip, folder, folder.name + '/' }
    end
    user.files.create(:file => zip_file.open, :public => true, :description => "Arquivo compactado", :folder => current_dir, :filename => zip_name)
    zip_file.close

    completed
  end

  private
    def compress_recursively zip, folder, path
      zip.add_dir(path)
      @total = @num + folder.files.count - 1
      folder.files.each do |file|
        zip.add_buffer(path + file.alias, file.file.file.read)
        at(@num, @total, "Compactando arquivo #{@num} de #{@total}: ./#{path}#{file.alias}")
        @num += 1
      end
      folder.children.each { |child| compress_recursively zip, child, path + child.name + '/' }
    end
end
