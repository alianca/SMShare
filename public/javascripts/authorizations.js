function install_clear_on_focus(box) {
  /* Escreve o texto do title no text_field, dessa maneira fazendo com que se o usuario desabilitou o javascript o text_field não vai conter lixo */
  box.find(".clear-on-focus").each(function () {
    if($(this).val() == "") {
      $(this).val($(this).attr("title"));
    }
  });

  /* Limpa quando o text_field ganhar o foco */
  box.find(".clear-on-focus").focus(function() {
    if($(this).val() == $(this).attr("title")) {
      $(this).val("");
    }
  });

  /* Retorna ao texto se o text_field está vazio quando ele perder o foco */
  box.find(".clear-on-focus").blur(function() {
    if($(this).val() == "") {
      $(this).val($(this).attr("title"));
    }
  });
}

function set_box_style(box, style) {
  install_clear_on_focus(box);
  box.css({
    'border': '1px solid ' + style.box_border,
    'background-color': style.box_background,
    'background-image': 'url(' + style.background + ')',
  });
  box.find('.box-header').css('color', style.header_text);
  box.find('.filename').css('color', style.header_text);
  box.find('.filesize').css('color', style.header_text);
  box.find('.box-header').css('background-color', style.header_background);
  box.find('.call-to-action').css('color', style.upper_text);
  box.find('.sms').css('color', style.para_text);
  box.find('.sms em').css('color', style.number_text);
  box.find('.price-box').css('background-color', style.header_background);
  box.find('.price').css('color', style.header_text);
  box.find('form').css('background-color', style.form_background);
  box.find('form').css('border', '1px solid ' + style.form_border);
  box.find('form .code_field').css('color', style.form_text);
  box.find('form input[type=submit]').css('background-color', style.button_background);
  box.find('form input[type=submit]').css('color', style.button_text);
  box.find('.have_one').css('color', style.bottom_text);
}

function fetch_style() {
  var style = $.parseJSON($('#style-data').text());
  style.background = $.trim($('#background-data').text());
  return style;
}

function bind_form(form) {
  form.submit(function() {
    var url = form.attr('url');
    if (url) {
      window.location = url;
    }
    else {
      $.ajax({
        url: form.attr('action'),
        data: form.serialize(),
        type: 'GET',
        dataType: 'JSON',
        error: function(data) {
          console.error(data.responseText);
        },
        success: function(data) {
          form.attr('url', data.url);
          var code_field = form.find('.code_field');
          code_field.val('Download liberado.');
          code_field.prop('disabled', true);
          window.location = data.url;
        }
      });
    }

    return false;
  });
}

$(document).ready(function() {
  var box = $('#downbox-overlay .download_box');
  set_box_style(box, fetch_style());
  bind_form(box.find('form'));

  (function fade_time(which) {
    $('.price:visible').hide();
    $('.price.' + which).fadeIn('fast');
    setTimeout(function(){
      fade_time(which == 'normal' ? 'pack' : 'normal');
    }, 3000);
  })('normal');

});
