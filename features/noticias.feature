# language: pt

Funcionalidade: EnviarNoticia
  Para ter notícias na página de notícias
  Como um administrador
  Eu quero poder enviar notícias
  
  Cenário: Notícia preenchida
    Dado que eu esteja logado como administrador
    Quando eu vou para a página de nova notícia
    E eu preencho "news_short" com "Exemplo de notícia resumida"
    E eu preencho "news_full" com "Exemplo de notícia completa"
    E eu aperto "Enviar"
    Então a notícia deve ser salva
  
  Cenário: Notícia em branco
    Dado que eu esteja logado como administrador
    Quando eu vou para a página de nova notícia
    E eu aperto "Enviar"
    Então a notícia nao deve ser salva
    
  Cenário: Editar notícia existente
    Dado que eu esteja logado como administrador
    E que exista uma notícia
    Quando eu vou para a página de edição da notícia
    E eu preencho "news_short" com "Notícia modificada"
    E eu preencho "news_full" com "Notícia modificada"
    E eu aperto "Enviar"
    Então a notícia deve ser modificada
    
  Cenário: Remover notícia
    Dado que eu esteja logado como administrador
    E que exista uma notícia
    Quando eu vou para a página de visualização da notícia
    E eu clico "Deletar"
    Então a notícia deve ser deletada
