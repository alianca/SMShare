Então /^a notícia deve ser salva$/ do
  @news = News.last
  @news.short.should == "Exemplo de notícia resumida"
  @news.full.should == "Exemplo de notícia completa"
end

Então /^a notícia nao deve ser salva$/ do
  @news = News.last
  @news.short.should_not == ""
  @news.full.should_not == ""
end

Dado /^que exista um admin$/ do
  @user = Factory.create :user, :email => "sage.darkfire@example.com", :password => "123456", :admin => true
end

Dado /^que eu esteja logado como administrador$/ do
  Dado %{que exista um admin}
  Quando %{eu vou para pagina de login}
  E %{eu preencho "Email" com "sage.darkfire@example.com"}
  E %{eu preencho "Senha" com "123456"}
  E %{eu aperto "Entrar"}
end
