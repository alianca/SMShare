$(document).ready(function() {

  /* Atualiza as caixas de cores na personalização */
  $("#style-customize ol li input[type=text]").change(function() {
    $(this).parent("li").children("div").css("background-color", $(this).val());
    switch ($(this).attr("name").match(/box_style\[([_a-z]+)\]/)[1]) {
    case "box_border":
      $("#download_box, style-customize .thumbnail").
        css("border", "1px solid " + $(this).val());
      break;
    case "box_background":
      $("#download_box, #style-customize .thumbnail").
        css("background-color", $(this).val());
      break;
    case "header_text":
      $("#download_box .box-header," +
        "#download_box .filename," +
        "#download_box .filesize," +
        "#style-customize .thumbnail .title").css("color", $(this).val());
      break;
    case "header_background":
      $("#download_box .box-header, #style-customize .thumbnail .title").
        css("background-color", $(this).val());
      break;
    case "upper_text":
      $("#download_box .call-to-action, #style-customize .thumbnail .top").
        css("color", $(this).val());
      break;
    case "para_text":
      $("#download_box .sms, #style-customize .thumbnail .middle span").
        css("color", $(this).val());
      break;
    case "number_text":
      $("#download_box .sms em, #style-customize .thumbnail .middle").
        css("color", $(this).val());
      break;
    case "cost_text":
      $("#download_box .price").css("color", $(this).val());
      break;
    case "form_background":
      $("#download_box .code_area, #style-customize .thumbnail .input").
        css("background-color", $(this).val());
      break;
    case "form_border":
      $("#download_box .code_area, #style-customize .thumbnail .input").
        css("border", "1px solid " + $(this).val());
      break;
    case "form_text":
      $("#download_box .code_area .code_field").css("color", $(this).val());
      break;
    case "button_background":
      $("#download_box .code_area .submit," +
        "#style-customize .thumbnail .input .thumb-button").
        css("background-color", $(this).val());
      break;
    case "button_text":
      $("#download_box .code_area .submit").css("color", $(this).val());
      break;
    case "bottom_text":
      $("#download_box .have_one").css("color", $(this).val());
      break;
    }
  });


  /* Ativa o color picker ao clicar na caixa de cor */
  $('#style-customize ol li input[type=text]').click(function() {
    // Posiciona o color picker ao lado da caixa selecionada
    var field_position = $(this).offset();
    var new_position = {
      'left' : (field_position.left - 205).toString() + 'px',
      'top'  : (field_position.top).toString() + 'px'
    };
    $('#color-picker').css(new_position);
    $('#color-picker').farbtastic(this);
    $('#color-picker').show('fast');
  });


  $('#style-customize ol li div').click(function() {
    $(this).parent("li").children("input[type=text]").click().focus();
  });


  /* Desativa o color picker quando a caixa de cor perde o foco */
  $('#style-customize ol li input[type=text]').blur(function() {
    $('#color-picker').hide('fast');
    $('#color-picker').remove_farbtastic();
  });



  /* Aplica o estilo nos thumbnails */
  function set_thumbnail_style(thumbnail, style) {
    thumbnail.css("border", "1px solid " + style.box_border);
    thumbnail.css("background-color", style.box_background);
    thumbnail.find(".title").css("color", style.header_text);
    thumbnail.find(".title").css("background-color", style.header_background);
    thumbnail.find(".top").css("color", style.upper_text);
    thumbnail.find(".middle span").css("color", style.para_text);
    thumbnail.find(".middle").css("color", style.number_text);
    thumbnail.find(".input").css("background-color", style.form_background);
    thumbnail.find(".input").css("border", "1px solid " + style.form_border);
    thumbnail.find(".input .thumb-button").css("background-color", style.button_background);
  }

  function update_thumbnails() {
    $('#style-list .style-list-item').each(function() {
      var thumb = $(this).find('.thumbnail');
      var style = $.parseJSON(thumb.find('.style').text());
      set_thumbnail_style(thumb, style);
    });
  }
  update_thumbnails();


  $("#style-customize ol li input[type=text]").bind('changed_style', function(e, style) {
    var field_name = $(this).attr("name").match(/box_style\[([_a-z]+)\]/)[1];
    $(this).attr("value", style[field_name]);
    $(this).change();
  });


  var code_options = '';
  function code_box_set(attribute, value, is_default) {
    var args = [];
    if (code_options !== '') {
      var arg_str = code_options.match(/<script src="(.*)" type="text\/javascript"><\/script>/)[1].split('?');
      arg_str = arg_str ? arg_str[1] : null;
      if (arg_str) {
        args = arg_str.split('&');
      }
    }

    code_options = '<script src="http://www.smshare.net.br/caixa_download/template';
    if (args.length > 0) {
      code_options += '?' + args.map(function(a) {
        if (a.split('=')[0] !== attribute) {
          return a;
        }
      }).filter(function(a) { // Remove all null/undefined
        return a;
      }).join('&');
    }

    if (!is_default) {
      code_options = [code_options, [attribute, value].join('=')].join(args.length > 0 ? '&' : '?');
    }

    code_options += '" type="text/javascript"></script>';

    $("#code-area input[type=text]").attr('value', code_options);
  }


  $("#style-list .style-list-item").click(function(e) {
    var thumb = $(this).find('.thumbnail');
    var style = $.parseJSON(thumb.find('.style').text());
    var style_id = $(this).attr('class').match(/id([a-f0-9]{24})/)[1];
    $('#style-customize ol li input[type=text]').trigger('changed_style', [style]);
    $('#style-list form #style_selected_style').attr('value', style_id);
    $('#style-list .style-list-item.selected').removeClass('selected');
    $(this).addClass('selected');

    code_box_set('estilo', style_id, $(this).hasClass("default"));

    /* Aplica o fundo padrão do estilo selecionado */
    $("#background-list .bg-list-item.id" + thumb.find('.bg').text()).click();

    e.stopImmediatePropagation();
  });

  /* Aplica o estilo padrão inicialmente */
  $("#style-list .style-list-item.default").click();


  function update_backgrounds() {
    $("#background-list .bg-list-item").each(function() {
      var thumb = $(this).find('.img-thumbnail');
      var url =  thumb.find('span').text();
      thumb.css("background", "url(" + url + ") no-repeat");
    });
  }
  update_backgrounds();


  $("#background-list .bg-list-item").click(function(e) {
    var url = $(this).find(".img-thumbnail span").text();
    var image_id = $(this).attr("class").match(/id([a-f0-9]{24})/)[1];
    if (url.length > 0) {
      $("#view #download_box").css("background-image", "url(" + url + ")");
    } else {
      $("#view #download_box").css("background-image", "none");
    }
    $("#background-list form #bg_selected_bg").attr("value", image_id);
    $("#background-list .bg-list-item.selected").removeClass("selected");
    $(this).addClass("selected");
    code_box_set('fundo', image_id, $(this).hasClass("default"));
    $('#box_style_box_image_id').val(image_id);
    e.stopImmediatePropagation();
  });


  /* Aplica a imagem de fundo padrão */
  $("#background-list .bg-list-item.default").click();


  /* Alterna a exibição da caixa do 'código de inserção' */
  $("#generate-code").click(function(e) {
    if ($("#code-area:visible")[0]) {
      $("#code-area").hide("fast");
    } else {
      $("#code-area").show("fast");
    }
    e.stopImmediatePropagation();
  });

  $("#code-area").click(function(e) {
    $(this).children("input[type=text]").select();
    e.stopImmediatePropagation();
  });

});
