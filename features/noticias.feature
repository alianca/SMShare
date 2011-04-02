# language: pt

Funcionalidade: EnviarNoticia
  Para ter notícias na página de notícias
  Como um administrador
  Eu quero poder enviar notícias
  
  Cenário: Notícia preenchida
    Dado que eu esteja logado como administrador
    Quando eu vou para a página de administrador
    E eu preencho "news_short" com "Exemplo de notícia resumida"
    E eu preencho "news_full" com "Exemplo de notícia completa"
    E eu aperto "Enviar"
    Então a notícia deve ser salva
  
  Cenário: Notícia em branco
    Dado que eu esteja logado como administrador
    Quando eu vou para a página de administrador
    E eu aperto "Enviar"
    Então a notícia nao deve ser salva
