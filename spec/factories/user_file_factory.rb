Factory.define :user_file do |uf|
  tempfile = Tempfile.new("somefile.txt")
  tempfile.write("Hello World!")
  tempfile.flush
  
  uf.file tempfile
  uf.description "Test file with 'Hello World!'"
  uf.owner { |owner| owner.association :user }
end