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

function set_box_style(box, style) {
  $(box).css("border", "1px solid " + style.box_border);
  $(box).css("background-color", style.box_background);
  $(box).css("background", "url(" + style.box_image + ")");
  $(box + " .box-header").css("color", style.header_text);
  $(box + " .filename").css("color", style.header_text);
  $(box + " .filesize").css("color", style.header_text);
  $(box + " .box-header").css("background-color", style.header_background);
  $(box + " .call-to-action").css("color", style.upper_text);
  $(box + " .sms").css("color", style.para_text);
  $(box + " .sms em").css("color", style.number_text);
  $(box + " .price").css("color", style.cost_text);
  $(box + " form").css("background-color", style.form_background);
  $(box + " form").css("border", "1px solid " + style.form_border);
  $(box + " form .code_field").css("color", style.form_text);
  $(box + " form .submit").css("background-color", style.button_background);
  $(box + " form .submit").css("color", style.button_text);
  $(box + " .have_one").css("color", style.bottom_text);
}

function after_create_box(box) {
  install_clear_on_focus(box);
  
  console.log(box);
  
  var style = jQuery.parseJSON($("#style-data").text());
  
  set_box_style(box, style);
  
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
    link = $(sender.target).parent("a");
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
  $.each(["/images/download_box/logo.png", "/images/download_box/fundo_padrao.png", "/images/download_box/botao-brilho.png"], function (i, val) {
    (new Image()).src = val;
  });  
});
