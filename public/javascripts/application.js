/* Mosta as notificações */
function show_notifications(hold) {
  hasAlert = $(".alert").html() != ""
  hasNotice = $(".notice").html() != ""
  if(hasAlert && hasNotice) {
    $(".alert").slideDown("slow", function () {
      setTimeout(function () {
        $(".alert").slideUp("slow", function () {
          $(".notice").slideDown("slow", function () {
            setTimeout(function () {
              $(".notice").slideUp("slow");
            }, 3000);
          });
        });
      }, 3000);
    });
  } else if(hasAlert) {
    $(".alert").slideDown("slow", function () {
      if (!hold) {
        setTimeout(function () {
          $(".alert").slideUp("slow");
        }, 3000);
      }
    });
  } else if(hasNotice) {
    $(".notice").slideDown("slow", function () {
      if (!hold) {
        setTimeout(function () {
          $(".notice").slideUp("slow");
        }, 3000);
      }
    });
  }
}

function force_hide_notifications() {
  $(".alert").slideUp("slow");
  $(".notice").slideUp("slow");
}

$(document).ready(function() {
  /* Escreve o texto do title no text_field, dessa maneira fazendo com que se o usuario desabilitou o javascript o text_field não vai conter lixo */
  $(".clear-on-focus").each(function () {
    if($(this).val() == "")
      $(this).val($(this).attr("title"));
  })

  /* Limpa quando o text_field ganhar o foco */
  $(".clear-on-focus").live("focus", function() {
    if($(this).val() == $(this).attr("title"))
      $(this).val("");
  });

  /* Retorna ao texto se o text_field está vazio quando ele perder o foco */
  $(".clear-on-focus").live("blur", function() {
    if($(this).val() == "")
      $(this).val($(this).attr("title"));
  });

  /* Troca o fundo do botão em mouse over */
  $("#search #search-button").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#search #search-button").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });

  /* Menu dropdown */
  $("#header-menu > li").mouseover(function () {
    $("ul", this).show();
  });
  $("#header-menu > li").mouseout(function () {
    $("ul", this).hide();
  });

  /* Formulário de Login */
  $("#login-link a").click(function () {
    if($("#login-form").css("display") == "none") {
      $("#login-form").css("display", "inline");
      return false;
    } else { /* Caso o formulario já esteja aberto vai para a pagina de login */
      return true;
    }
  });

  show_notifications(false);

  /* Arruma o menu no Webkit */
  if($.browser.webkit) {
    $("#header #header-menu .title > a").css("padding-bottom", "9px");
    $("#header #header-menu .title > span").css("padding-bottom", "9px");
  }

  /* Arruma o file_field no Firefox */
  if($.browser.mozilla || $.browser.msie) {
      $("#new_user_file #user_file_file").css("font-size", "12px");
      $("#new_user_file #user_file_file").css("height", "22px");
      $("#new_user_file #user_file_file").css("background", "none");
      $("#new_user_file #user_file_file_input").css("background", "url(/images/user_files/campo.png)");

      if($.browser.mozilla) {
        $("#new_user_file #user_file_file").attr("size", 51);
        $("#new_user_file #user_file_file_input").css("padding", "6px 8px 5px 8px");
      }
      if($.browser.msie) {
        $("#new_user_file #user_file_file").css("width", "475px");
        $("#new_user_file #user_file_file_input").css("padding", "6px 8px 3px 0");
      }
  }

  /* Estilo da checkbox */
  $("input[type=checkbox]").each(function() {
    var fake_cb = $(document.createElement("span"));
    var real_cb = $(this);

    fake_cb.addClass("checkbox");
    real_cb.after(fake_cb);
    real_cb.hide();

    if (!real_cb.parent().is('label')) {
      fake_cb.click(function(e) {
        real_cb.attr('checked', !real_cb.attr('checked'));
        real_cb.click();
        real_cb.attr('checked', !real_cb.attr('checked'));
        real_cb.change();
        e.stopImmediatePropagation();
      });
    }

    real_cb.change(function() {
      if (real_cb.attr("checked")) {
        var bg_position = "0 -" + fake_cb.css("height");
      } else {
        var bg_position = "0 0";
      }
      fake_cb.css("background-position", bg_position);
    });

    // Estado inicial
    $(this).change();
  });
});

/* Personalização do File Field */
$.make_file_field = function(real_field) {
  var field_container = $(document.createElement("div"))
  var fake_field = $(document.createElement("div"));
  var filename = $(document.createElement("span"));
  var button = $(document.createElement("div"));

  field_container.addClass("field-container");
  fake_field.addClass("file-field");
  button.addClass("file-button");
  filename.addClass("file-name");

  button.text("Browse");

  field_container.append('<span class="left"></span>');
  fake_field.append(filename);
  fake_field.append(button);
  field_container.append(fake_field)
  field_container.append('<span class="right"></span>');

  real_field.after(field_container);

  real_field.css("opacity", "0");
  real_field.css("position", "absolute");

  fake_field.click(function() {
    real_field.click();
  });

  real_field.change(function() {
    filename.text(real_field.val());
  });
};

$.cacheImages = function () {
  $.each(arguments, function (i, val) {
    (new Image()).src = val;
  });
};

/* Faz pre-cache das imagens do menu */
$.cacheImages("/images/layouts/menu/bullet-normal.png", "/images/layouts/menu/bullet-mouseover.png", "/images/layouts/menu/dropdown-over.png", "/images/layouts/menu/nodropdown-over.png", "/images/layouts/login/botao-on.png", "/images/layouts/login/campo.png");
