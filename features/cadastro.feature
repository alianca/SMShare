# language: pt

Funcionalidade: Cadastro
  Para ter o controle da autoria dos arquivos
  Como um visitante
  Eu quero poder fazer um cadastro
  
  Cenário: Cadastro correto
    Dado que eu não esteja logado
    Quando eu vou para a página de cadastro
    E eu preencho "Seu nome completo:" com "Robin Sage"
    E eu preencho "Seu e-mail (válido):" com "robinsage@iamsafe.com"
    E eu preencho "Escolha um login:" com "sage"
    E eu preencho "Escolha uma senha:" com "foolingyou"
    E eu preencho "Confirme a senha:" com "foolingyou"
    E eu marco "Declaro que li e concordo com os Termos e Condições."
    E eu aperto "Confirmar"
    Então o usuário deve ser salvo
    E eu devo estar na pagina inicial do painel
  
  
  Cenário: Campos em branco
    Dado que eu não esteja logado
    Quando eu vou para a página de cadastro
    E eu aperto "Confirmar"
    Então eu devo estar na página de cadastro
    E eu devo ver os erros para os campos obrigatórios