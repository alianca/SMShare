Dado /^que exista um usuario$/ do
  @user = Factory.create :user, :email => "sage.darkfire@example.com", :password => "123456"
end

Dado /^que eu esteja logado como um usuario$/ do
  Dado %{que exista um usuario}
  Quando %{eu vou para pagina de login}
  E %{eu preencho "Email" com "sage.darkfire@example.com"}
  E %{eu preencho "Senha" com "123456"}
  E %{eu aperto "Entrar"}
end

Dado /^que eu não esteja logado$/ do
  Quando %{eu vou para pagina de logout}
end

Então /^eu devo estar logado$/ do
  page.should have_css("#profile-link")
end
