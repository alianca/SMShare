# language: pt

Funcionalidade: Caixa de Download
  Para que os arquivos possam ser baixados apartir de outros sites
  Como um usuário que possui arquivos
  Eu quero poder colocar uma caixa de download no meu site
  
  
  Cenário: Link para o download sem javascript ativo
    Dado que exista o arquivo
    E que eu esteja na pagina de exemplo do arquivo
    Quando eu clicar no link para o arquivo
    Então eu devo estar na pagina do arquivo
    
  @javascript
  Cenário: Link para o download com javascript ativo
    Dado que exista o arquivo
    E que eu esteja na pagina de exemplo do arquivo
    Quando eu clicar no link para o arquivo
    Então eu devo estar na pagina de exemplo do arquivo
    E eu devo ver a caixa de download  
  
  @rack_test
  Cenário: Download via caixa de download
    Dado que exista o arquivo
    Quando eu vou para a caixa de download do arquivo
    E eu preencho "Codigo recebido" com "123456"
    E eu aperto "Download"
    Então eu devo baixar o arquivo
  