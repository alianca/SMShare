# language: pt

Funcionalidade: Pagina Inicial
  Para que os usuarios não fiquem perdidos ao chegar ao site
  Como um visitante
  Eu quero ser recebido com uma pagina inicial
  
  Cenário: Visitar Pagina Inicial
    Dado que eu não esteja logado
    E que eu esteja na raiz do site
    Então eu devo estar na pagina inicial
    
  Cenário: Pagina Incial como usuario logado
    Dado que eu esteja logado como um usuario
    E que eu esteja na raiz do site
    Então eu devo estar na pagina inicial do painel
    
  @javascript
  Cenário: Logar-se via Javascript
    Dado que eu não esteja logado
    E que eu esteja na pagina inicial
    E que exista um usuario
    Quando eu clico no link para login
    E eu preencho "Email" com "sage.darkfire@example.com"
    E eu preencho "Senha" com "123456"
    E eu aperto "Entrar"
    Então eu devo estar logado