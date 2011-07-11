Então /^a notícia deve ser salva$/ do
  @news = News.last
  @news.title.should == "Título da notícia de exemplo"
  @news.short.should == "Exemplo de notícia resumida"
  @news.full.should == "Exemplo de notícia completa"
end

Então /^a notícia nao deve ser salva$/ do
  @news = News.last
  @news.title.should_not == ""
  @news.short.should_not == ""
  @news.full.should_not == ""
end

Dado /^que exista um admin$/ do
  @user = User.create(:name => 'user teste', :nickname => 'user_teste', :email => "user_teste@example.com", :password => "123456", :admin => true)
  @user.save
end

Dado /^que eu esteja logado como administrador$/ do
  Dado %{que exista um admin}
  Quando %{eu vou para pagina de login}
  E %{eu preencho "Email" com "user_teste@example.com"}
  E %{eu preencho "Senha" com "123456"}
  E %{eu aperto "Entrar"}
end

Dado /^que exista uma notícia$/ do
  @noticia = News.create(:title => "Título da notícia", :short => "Notícia resumida", :full => "Notícia completa")
end

Então /^a notícia deve ser modificada$/ do
  @news = News.last
  @news.title.should == "Notícia modificada"
  @news.short.should == "Notícia modificada"
  @news.full.should == "Notícia modificada"
end

Então /^a notícia deve ser deletada$/ do
  @news = News.last
  @news.should == nil
end

