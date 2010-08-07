# language: pt

Funcionalidade: Download
  Para que os usuarios possam ficar ricos
  Como um visitante
  Eu quero poder baixar os arquivos dos usuarios
  
  Cenário: Download de um arquivo valido
    Dado que exista o arquivo
    Quando eu vou para o download do arquivo
    Então eu devo baixar o arquivo
    
  Cenário: Download de um arquivo invalido
    Dado que não exista o arquivo
    Quando eu vou para o download do arquivo
    Então eu devo receber um erro de arquivo não encontrado