# language: pt

Funcionalidade: Upload
  Para que os usuarios possam ficar ricos
  Como um usuario
  Eu quero poder enviar arquivos
  
  Cenário: Upload de arquivo como um usuario logado
    Dado que eu esteja logado como um usuario
    E que exista um arquivo de teste
    Quando eu vou para a pagina de upload
    E eu preencho o arquivo com o arquivo de teste
    E eu preencho a descrição com "Arquivo de Teste"
    E eu marco "Arquivo público"
    E eu aperto "Enviar"
    Então o arquivo deve ser salvo