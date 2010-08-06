Dado /^que exista o arquivo$/ do
  @tempfile = Tempfile.new("somefile.txt")
  @tempfile.write("Hello World!")
  @tempfile.flush
  
  @file = UserFile.create!(:file => @tempfile)
end

Então /^eu devo baixar o arquivo$/ do
  page.body.should == "Hello World!"
end

Dado /^que não exista o arquivo$/ do
  @file = UserFile.new # Cria o arquivo mas nunca salva para ele não existir
end

Então /^eu devo receber um erro de arquivo não encontrado$/ do
  page.driver.response.status.should == 404
  page.driver.response.content_type.should == "text/html"
end