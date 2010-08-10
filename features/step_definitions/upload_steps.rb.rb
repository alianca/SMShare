Dado /^que eu esteja logado como um usuario$/ do
  # Cria o usuario
  user = User.create! :name => "Sage Darkfire", 
      :email => "sage.darkfire@example.com", :password => "123456"
  
  # Loga o usuario    
  Quando %{eu vou para pagina de login}
  E %{eu preencho "user[email]" com "sage.darkfire@example.com"}
  E %{eu preencho "user[password]" com "123456"}
  E %{eu aperto "Sign in"}
end

Dado /^que exista um arquivo de teste$/ do
  open(Rails.root + "tmp/test_file.txt", "w") do |f|
    f.write("Hello World!")
  end
end

Quando /^eu preencho o arquivo com o arquivo de teste$/ do
  Quando %{eu preencho "file" com "#{Rails.root + "tmp/test_file.txt"}"}
end

Quando /^eu preencho a descrição com "([^"]*)"$/ do |description|
  Quando %{eu preencho "description" com "#{description}"}
end
