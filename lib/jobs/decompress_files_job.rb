require 'zipruby'
require 'lib/file_name'

class Jobs::DecompressFilesJob < Resque::JobWithStatus
  @queue = :decompress

  def perform
    user = User.find(options["user_id"])
    files = JSON.parse(options["files"])

    files = UserFile.where(:_id.in => (files.collect { |id| BSON::ObjectId(id) }))

    files.each do |file|
      Zip::Archive.open_buffer(file.file.file.read) do |zip|
        total = zip.count
        zip.each_with_index do |z, i|
          unless z.directory?
            components = z.name.split('/')
            filename = FileName.sanitize(components.last)
            path = components[0..-2]

            current_dir = file.folder
            path.each do |component|
              match = current_dir.children.where(:name => component).first
              current_dir = match ? match : current_dir.children.create(:name => component, :owner => user)
            end

            at(i + 1, total, "Descompactando #{file.alias}: ./#{z.name} (#{i + 1} de #{total})")

            temp_file = Tempfile.new filename
            temp_file.content_type = z.content_type
            temp_file.write z.read
            temp_file.rewind
            user.files.create(:file => temp_file.open, :public => true, :description => "Arquivo", :folder => current_dir, :filename => filename)
            temp_file.close
          end
        end
      end
    end
    completed
  end
end
