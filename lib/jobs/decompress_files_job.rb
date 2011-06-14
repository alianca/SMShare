require 'zipruby'

class Jobs::DecompressFilesJob
  @queue = :decompress
  
  def self.perform(user_id, file_id)
    user = User.find(user_id["$oid"])
    file = UserFile.find(file_id["$oid"])
    
    Zip::Archive.open_buffer(file.file.file.read) do |zip|
      zip.each do |z|
        unless z.directory?
          components = z.name.split('/')
          filename = components.last
          path = components[0..-2]
          
          current_dir = file.folder
          path.each do |component|
            match = current_dir.children.where(:name => component).first
            current_dir = match ? match : current_dir.children.create(:name => component, :owner => user)
          end
          
          temp_file = Tempfile.new filename
          temp_file.write z.read
          temp_file.rewind
          user.files.create(:file => temp_file.open, :public => true, :description => "PLACEHOLDER", :folder => current_dir, :filename => filename)
          temp_file.close
        end
      end
    end
  end
end
