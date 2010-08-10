Dado /^que eu esteja logado como um usuario$/ do
  # Cria o usuario
  @user = User.create! :name => "Sage Darkfire", 
      :email => "sage.darkfire@example.com", :password => "123456"
  
  # Loga o usuario    
  Quando %{eu vou para pagina de login}
  E %{eu preencho "user[email]" com "sage.darkfire@example.com"}
  E %{eu preencho "user[password]" com "123456"}
  E %{eu aperto "Sign in"}
end

Dado /^que eu não esteja logado$/ do
  Quando %{eu vou para pagina de logout}
end

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

Dado /^que exista um arquivo de teste$/ do
  open(Rails.root + "tmp/test_file.txt", "w") do |f|
    f.write("Hello World!")
  end
end

Quando /^eu preencho o arquivo com o arquivo de teste$/ do
  Quando %{eu preencho "user_file[file]" com "#{Rails.root + "tmp/test_file.txt"}"}
end

Quando /^eu preencho a descrição com "([^"]*)"$/ do |description|
  Quando %{eu preencho "user_file[description]" com "#{description}"}
end

Então /^o arquivo deve ser salvo$/ do
  file = @user.files.first
  file.file.file.read.should == "Hello World!"
end