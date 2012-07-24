function install_clear_on_focus(context) {
  /* Escreve o texto do title no text_field, dessa maneira fazendo com que se o usuario desabilitou o javascript o text_field não vai conter lixo */
  $(context + " .clear-on-focus").each(function () {
    if($(this).val() == "") {
      $(this).val($(this).attr("title"));
    }
  })

  /* Limpa quando o text_field ganhar o foco */
  $(context + " .clear-on-focus").focus(function() {
    if($(this).val() == $(this).attr("title")) {
      $(this).val("");
    }
  });

  /* Retorna ao texto se o text_field está vazio quando ele perder o foco */
  $(context + " .clear-on-focus").blur(function() {
    if($(this).val() == "") {
      $(this).val($(this).attr("title"));
    }
  });
}

function set_box_style(box, style) {
  $(box).css("border", "1px solid " + style.box_border);
  $(box).css("background-color", style.box_background);
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
  $(box + " form input[type=submit]").css("background-color", style.button_background);
  $(box + " form input[type=submit]").css("color", style.button_text);
  $(box + " .have_one").css("color", style.bottom_text);
}

function after_create_box(box, base_url) {
  var style = jQuery.parseJSON($("#style-data").text());
  var background = base_url + $.trim($("#background-data").text());

  install_clear_on_focus(box);

  set_box_style(box, style);
  $(box).css({
    'position': 'relative',
    'background-image': 'url(' + background + ')',
    'margin': 'auto',
    'top': '50%',
    'margin-top': '-20%'
  });
}

function get_base_url(url) {
  var matches = url.match(/(http:\/\/.*)\/arquivos/);
  if (matches) {
    return matches[1];
  }
  return '';
}

function load_css(base_url) {
  var css = document.createElement('link');
  css.type = 'text/css';
  css.rel = 'stylesheet';
  css.href = base_url + '/stylesheets/authorizations.css';
  css.media = 'screen';
  document.getElementsByTagName("head")[0].appendChild(css);

  /* Faz cache das imagens para a caixa */
  $.each([
    "/images/download_box/logo.png",
    "/images/download_box/botao-brilho.png"
  ], function(i, val) {
    (new Image()).src = base_url + val;
  });
}

$(document).ready(function() {

  $("a[rel~=\"smshare\"]").click(function(e) {
    e.stopImmediatePropagation();
    return false;
  });

  $("a[rel~=\"smshare\"]").hover(function(e) {
    if ($("#downbox-overlay")[0]) {
      return true;
    }

    e.stopImmediatePropagation();

    var button = e;
    var link = button.srcElement || button.target;

    while (link.localName != "a") {
      link = $(link).parent("a.download-button")[0];
    }

    link = $(link);
    /* Pega os dados do link */
    var path = link.attr("href");
    var user_file_id = path.match(/arquivos\/([0-9a-f]{24})\/?$/)[1];

    var base_url = get_base_url(path);
    load_css(base_url);

    /* Cria a caixa de download via AJAX */
    $.ajax({
      url: '/autorizacao/new?file_id=' + user_file_id + '&' + options,
      type: "GET",
      async: false,
      success: function(data) {
        link.after(data);
      }
    });

    /* Executa as funções após a criação da caixa */
    after_create_box("#download_box-" + user_file_id, base_url);

    var overlay = $("#downbox-overlay");
    $("body").prepend(overlay);
    overlay.css({
      'z-index': 8001,
      'position': 'absolute',
      'background': 'transparent',
      'width': '500px',
      'height': '300px',
      'line-height': '500px',
      'top': e.pageY - 50,
      'left': e.pageX - 450
    });

    overlay.hover(function() {}, function() {
      overlay.remove();
    });

    /* Retorna falso para o link não ser seguido caso tudo tenha dado certo */
    return false;
  }, function() {});


});
