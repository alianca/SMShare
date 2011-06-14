require 'zipruby'

class Jobs::CompressFilesJob
  @queue = :compress
  
  def self.perform(user_id, folder_id, parameter)
    param = JSON.parse(parameter)
    param["files"].delete_if { |f| f.blank? }
    
    files = UserFile.where(:_id.in => (param["files"].collect { |id| BSON::ObjectId(id) }))
    folders = Folder.where(:_id.in => (param["files"].collect { |id| BSON::ObjectId(id) }))
    current_dir = Folder.find(folder_id["$oid"])
    user = User.find(user_id["$oid"])
    
    zip_name = param["filename"]
    zip_name += '.zip' unless zip_name =~ /.*\.zip$/
    zip_file = Tempfile.new zip_name
    Zip::Archive.open(zip_file.path, Zip::CREATE, Zip::BEST_SPEED) do |zip|
      files.each { |file| zip.add_buffer(file.alias, file.file.file.read) }
      folders.each { |folder| compress_recursively zip, folder, folder.name + '/' }
    end
    user.files.create(:file => zip_file.open, :public => true, :description => "Arquivo compactado", :folder => current_dir, :filename => zip_name)
    zip_file.close
  end
  
  private
    def self.compress_recursively zip, folder, path
      zip.add_dir(path)
      folder.files.each { |file| zip.add_buffer(path + file.alias, file.file.file.read) }
      folder.children.each { |child| compress_recursively zip, child, path + child.name + '/' }
    end
end
