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
