# language: pt

Funcionalidade: Arquivos
  Para que os usuarios possam ficar ricos
  Eu quero poder ter arquvos no smShare
  
  Cenário: Download de arquivo valido
    Dado que exista o arquivo
    Quando eu vou para o download do arquivo
    Então eu devo baixar o arquivo
    
  Cenário: Download de arquivo invalido
    Dado que não exista o arquivo
    Quando eu vou para o download do arquivo
    Então eu devo receber um erro de arquivo não encontrado
    
  Cenário: Upload de arquivo como um usuario logado
    Dado que eu esteja logado como um usuario
    E que exista um arquivo de teste
    Quando eu vou para a pagina de upload
    E eu preencho o arquivo com o arquivo de teste
    E eu preencho a descrição com "Arquivo de Teste"
    E eu marco "Arquivo público"
    E eu aperto "Enviar"
    Então o arquivo deve ser salvo

  Cenário: Upload de arquivo deslogado
    Dado que eu não esteja logado
    Quando eu vou para a pagina de upload
    Então eu devo estar na pagina de login