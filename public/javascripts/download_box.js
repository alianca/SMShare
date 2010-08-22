$(document).ready(function() {
  $("a[rel~=\"smshare\"]").click(function (sender) {
    /* Pega os dados do link */
    link = $(sender.target);
    user_file_id = link.attr("href").match(/arquivos\/([0-9a-f]{24})\/?$/)[1];
    
    /* Verifica se já está aberto para poder fechar */
    if($("#download_box-" + user_file_id)[0]) {
      $("#download_box-" + user_file_id).remove();      
      
      return false;
    }
    
    /* Cria a caixa de download via AJAX */
    $.ajax({
      url: link.attr("href") + "/download_box",
      type: "POST",
      async: false,
      success: function (data) {
        link.after(data);
      }
    });
    
    /* TODO Posiciona a caixa perto do link */
    
    /* Escreve o texto do title no text_field, dessa maneira fazendo com que se o usuario desabilitou o javascript o text_field não vai conter lixo */
    $(".clear-on-focus").each(function () {
      if($(this).val() == "")
        $(this).val($(this).attr("title"));
    })
    
    /* Limpa quando o text_field ganhar o foco */
    $(".clear-on-focus").focus(function() {
      if($(this).val() == $(this).attr("title"))
        $(this).val("");
    });

    /* Retorna ao texto se o text_field está vazio quando ele perder o foco */
    $(".clear-on-focus").blur(function() {
      if($(this).val() == "")
        $(this).val($(this).attr("title"));
    });
    
    /* Fecha após o download do arquivo */
    $("#download_box-" + user_file_id + " form").submit(function () {
      $("#download_box-" + user_file_id).hide();
      setTimeout(function () {
        $("#download_box-" + user_file_id).remove();
      }, 200);       
      return true;
    });
        
    /* Retorna falso para o link não ser seguido caso tudo tenha dado certo */
    return false;
  });
});