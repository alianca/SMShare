function install_clear_on_focus(context) {
  /* Escreve o texto do title no text_field, dessa maneira fazendo com que se o usuario desabilitou o javascript o text_field não vai conter lixo */
  $(context + " .clear-on-focus").each(function () {
    if($(this).val() == "")
      $(this).val($(this).attr("title"));
  })
  
  /* Limpa quando o text_field ganhar o foco */
  $(context + " .clear-on-focus").focus(function() {
    if($(this).val() == $(this).attr("title"))
      $(this).val("");
  });

  /* Retorna ao texto se o text_field está vazio quando ele perder o foco */
  $(context + " .clear-on-focus").blur(function() {
    if($(this).val() == "")
      $(this).val($(this).attr("title"));
  });
}

function after_create_box(box) {
  install_clear_on_focus(box)
  
  /* Fecha após o download do arquivo */
  $(box + " form").submit(function () {
    $(box).hide();
    setTimeout(function () {
      $(box).remove();
    }, 200);       
    return true;
  });
}

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
    
    /* Executa as funções após a criação da caixa */
    after_create_box("#download_box-" + user_file_id); 
    
    /* Retorna falso para o link não ser seguido caso tudo tenha dado certo */
    return false;
  });
  
  /* TODO Pegar base url da url do link */
  
  var css = document.createElement('link');
  css.type = 'text/css';
  css.rel = 'stylesheet';
  css.href = '/stylesheets/download_box.css';
  css.media = 'screen';
  document.getElementsByTagName("head")[0].appendChild(css);
  
  /* Faz cache das imagems para a caixa */
  $.each(["/images/download_box/logo.png", "/images/download_box/fundo.png", "/images/download_box/input.png", "/images/download_box/botao-off.png", "/images/download_box/botao-on.png"], function (i, val) {
    (new Image()).src = val;
  });  
});
