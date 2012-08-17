Factory.define :download do |uf|
  uf.file { |file| file.association :user_file }
  uf.downloaded_by_ip "127.0.0.1"
end
