Factory.define :user_file do |uf|
  uf.filename 'fake_file.txt'
  uf.filepath '/some/fake/path'
  uf.filesize 42
  uf.filetype 'text/plain'
  uf.description "Fake test file"
  uf.owner { |owner| owner.association :user }
end
