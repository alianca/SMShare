$(document).ready(function() {
  if($("input#all_files")) {
    $("input#all_files").live("click", function() {
      $("input.select_file").attr("checked", $("input#all_files").attr("checked"));
      $("input.select_file").each(function() {
        $(this).change();
      });
    });
  }
  
  /* Troca o fundo do botão em mouse over */
  $("#folder_new #folder_submit").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });
  
  /* Volta o fundo padrão quando perde o mouse over */
  $("#folder_new #folder_submit").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });
  
  function show_form(name) {
    if($("#actions_forms " + name + ":visible")[0]) {
      $("#actions_forms form").hide();
      $("#form_placeholder").hide();
    } else {
      $("#actions_forms form").hide();
      $("#actions_forms " + name).show();
      $("#form_placeholder").show();
    }
  }
  
  function show_rename() {
    if ($("#actions_forms #rename:visible")[0]) {
      $("#actions_forms form").hide();
      $("#rename_placeholder").hide();
    } else {
      $("#actions_forms form").hide();
      $("#actions_forms #rename").show();
      $("#rename_placeholder").show();
    }
  }
  
  $(".actions_menu .create a").click(function (e) {
    show_form("#new_folder");
    e.stopImmediatePropagation();
  });
  
  $(".actions_menu .move a").click(function (e) {
    show_form("#move");
    e.stopImmediatePropagation();
  });
  
  $(".actions_menu .rename a").click(function (e) {
    if (!($(this).hasClass("off"))) {
      show_rename();
    }
    e.stopImmediatePropagation();
  });
  
  /* Copia a seleção de arquivos da tabela para a lista oculta */
  $(".file_list .select_file").change(function () {
    $("#actions_forms .hidden_file_list input[value=" + this.value + "]").attr("checked", $(this).attr("checked"));
    
    if ($(this).attr("checked")) {
      $("#" + this.value).removeClass("hidden-field");
      $("#rename_placeholder").css("margin-bottom", $("#rename").height() + 27);
    } else {
      $("#" + this.value).addClass("hidden-field");
      $("#rename_placeholder").css("margin-bottom", $("#rename").height() + 27);
    }
    
    var has_selected = false;
    $("#actions_forms .hidden_file_list input[type=checkbox]").each(function() {
      if ($(this).attr("checked")) {
        has_selected = true;
      }
    });
    
    if (has_selected) {
      $(".actions_menu .rename a").removeClass("off");
    } else {
      $(".actions_menu .rename a").addClass("off");
      if ($("#actions_forms #rename:visible")[0]) {
        $("#actions_forms form").hide();
        $("#rename_placeholder").hide();
      }
    }
    
  });
  
  /* Dropdown da sidebar */
  $("#sidebar li.menu").click(function(e) {
    if (!$(this).hasClass("no-dropdown") && this == e.target) {
      if ($(this).hasClass("active")) {
        $(this).children("ul.dropdown").hide("fast");
        $(this).removeClass("active");
      } else {
        $(this).children("ul.dropdown").show("fast");
        $(this).addClass("active");
      }
    }
    e.stopImmediatePropagation();
  });
  
  /* Atualiza as caixas de cores na personalização */
  $("#style-customize ol li input[type=text]").change(function() {
    $(this).parent("li").children("div").css("background-color", $(this).val());
    switch ($(this).attr("name").match(/box_style\[([_a-z]+)\]/)[1]) {
      case "box_border":
        $("#download_box, \
           #style-customize .thumbnail").css("border", "1px solid " + $(this).val());
        break;
      case "box_background":
        $("#download_box, \
           #style-customize .thumbnail").css("background-color", $(this).val());
        break;
      case "header_text":
        $("#download_box .box-header, \
           #download_box .filename, \
           #download_box .filesize, \
           #style-customize .thumbnail .title").css("color", $(this).val());
        break;
      case "header_background":
        $("#download_box .box-header, \
           #style-customize .thumbnail .title").css("background-color", $(this).val());
        break;
      case "upper_text":
        $("#download_box .call-to-action, \
           #style-customize .thumbnail .top").css("color", $(this).val());
        break;
      case "para_text":
        $("#download_box .sms, \
           #style-customize .thumbnail .middle span").css("color", $(this).val());
        break;
      case "number_text":
        $("#download_box .sms em, \
           #style-customize .thumbnail .middle").css("color", $(this).val());
        break;
      case "cost_text":
        $("#download_box .price").css("color", $(this).val());
        break;
      case "form_background":
        $("#download_box .code_area, \
           #style-customize .thumbnail .input").css("background-color", $(this).val());
        break;
      case "form_border":
        $("#download_box .code_area, \
           #style-customize .thumbnail .input").css("border", "1px solid " + $(this).val());
        break;
      case "form_text":
        $("#download_box .code_area .code_field").css("color", $(this).val());
        break;
      case "button_background":
        $("#download_box .code_area .submit, \
           #style-customize .thumbnail .input .thumb-button").css("background-color", $(this).val());
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
  
  /* Aplica o estilo padrão inicialmente */
  $("#style-customize ol li input[type=text]").change();
  
  /* Aplica o estilo nos thumbnails */
  function set_thumbnail_style(thumbnail, style) {
    $(thumbnail).css("border", "1px solid " + style.box_border);
    $(thumbnail).css("background-color", style.box_background);
    $(thumbnail + " .title").css("color", style.header_text);
    $(thumbnail + " .title").css("background-color", style.header_background);
    $(thumbnail + " .top").css("color", style.upper_text);
    $(thumbnail + " .middle span").css("color", style.para_text);
    $(thumbnail + " .middle").css("color", style.number_text);
    $(thumbnail + " .input").css("background-color", style.form_background);
    $(thumbnail + " .input").css("border", "1px solid " + style.form_border);
    $(thumbnail + " .input .thumb-button").css("background-color", style.button_background);
  }
  
  function update_thumbnails() {
    var count = $("#style-list span.style").text();
    for (var i = 0; i < count; i++) {
      var style = jQuery.parseJSON($("#style-list .thumbnail.index" + i.toString() + " .style").text());
      set_thumbnail_style("#style-list .thumbnail.index" + i.toString(), style);
    }
  }
  update_thumbnails();
  
  $("#style-customize ol li input[type=text]").bind('changed_style', function(e, style) {
    var field_name = $(this).attr("name").match(/box_style\[([_a-z]+)\]/)[1];
    $(this).attr("value", style[field_name]);
    $(this).change();
  });
  
  var code_options = '';
  function code_box_set(attribute, value) {
    var args = [];
    if (code_options != '')
      args = code_options.split('&');
    code_options = '';
    if (args.length > 0) {
      for (var i = 0; i < args.length; i++) {
        var argument = args[i].split('=');
        if (argument[0] != attribute) {
          code_options += argument[0] + '=' + argument[1];
          code_options += '&';
        }
      }
    }
    code_options += attribute + '=' + value;
    $("#code-area input[type=text]").attr('value', code_options);
  }
  
  $("#style-list .style-list-item").click(function(e) {
    var style = jQuery.parseJSON($(this).children(".thumbnail").children(".style").text());
    var style_id = $(this).attr("class").match(/id([a-f0-9]{24})/)[1];
    $("#style-customize ol li input[type=text]").trigger('changed_style', [style]);
    $("#style-list form #style_selected_style").attr("value", style_id);
    $("#style-list .style-list-item.selected").removeClass("selected");
    $(this).addClass("selected");
    code_box_set('style', style_id);
    e.stopImmediatePropagation();
  });
  
  function update_backgrounds() {
    var count = $("#background-list .count").text();
    for (var i = 0; i < count; i++) {
      var url = $("#background-list .img-thumbnail.index" + i.toString() + " span").text();
      $("#background-list .img-thumbnail.index" + i.toString()).css("background", "url(" + url + ") no-repeat");
    }
  }
  update_backgrounds();
  
  $("#background-list .bg-list-item").click(function(e) {
    var url = $(this).children(".img-thumbnail").children("span").text();
    var image_id = $(this).attr("class").match(/id([a-f0-9]{24})/)[1];
    if (url.length > 0) {
      $("#view #download_box").css("background-image", "url(" + url + ")");
    } else {
      $("#view #download_box").css("background-image", "none");
    }
    $("#background-list form #bg_selected_bg").attr("value", image_id);
    $("#background-list .bg-list-item.selected").removeClass("selected");
    $(this).addClass("selected");
    code_box_set('background', image_id);
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

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/layouts/botao-on.png");

