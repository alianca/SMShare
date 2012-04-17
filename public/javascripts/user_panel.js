$(document).ready(function() {
  if($("input#all_files")) {
    $("input#all_files").click(function() {
      $(".select_file").attr("checked", $(this).attr("checked") && true);
      $(".select_file").change();
    });
  }

  /* Troca o fundo do botão em mouse over */
  $("#folder_new #folder_submit").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)");
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#folder_new #folder_submit").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)");
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
    if (!($(this).hasClass("off"))) {
      show_form("#move");
    }
    e.stopImmediatePropagation();
  });

  $(".actions_menu .rename a").click(function (e) {
    if (!($(this).hasClass("off"))) {
      show_rename();
    }
    e.stopImmediatePropagation();
  });

  $(".actions_menu .compress a").click(function (e) {
    if (!($(this).hasClass("off"))) {
      show_form("#compress");
    }
    e.stopImmediatePropagation();
  });

  function selected_boxes() {
    var result = { any: false, all: true };
    $(".file_list .select_file").each(function() {
      var checked = $(this).attr("checked");
      result.any = result.any || checked;
      result.all = result.all && checked;
    });
    return result;
  }

  /* Copia a seleção de arquivos da tabela para a lista oculta */
  $(".file_list .select_file").change(function () {
    $("#actions_forms .hidden_file_list input[value=" + this.value + "]").attr("checked", $(this).attr("checked"));
    $(".actions_menu .hidden_file_list input[value=" + this.value + "]").attr("checked", $(this).attr("checked"));

    if ($(this).attr("checked")) {
      $("#" + $(this).attr("value")).removeClass("hidden-field");
      $("#rename_placeholder").css("margin-bottom", $("#rename").height() + 27);
    } else {
      $("#" + $(this).attr("value")).addClass("hidden-field");
      $("#rename_placeholder").css("margin-bottom", $("#rename").height() + 27);
    }

    if (selected_boxes().any) {
      $(".actions_menu .need-files.off").removeClass("off");
    } else {
      $(".actions_menu .need-files").addClass("off");
      if ($("#actions_forms .need-files:visible")[0]) {
        $("#actions_forms").hide();
        $("#rename_placeholder").hide();
      }
    }
  });


  /* Dropdown da sidebar */
  $("#sidebar li.menu").click(function(e) {
    if (!$(this).hasClass("no-dropdown") && this === e.target) {
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

  /* Helpers para os multiplos arquivos */
  function ms_to_hour_min_sec(ms) {
    var secs = Math.floor(ms / 1000) % 60;
    if(secs < 10) { secs = "0" + secs; }
    var mins = Math.floor(ms / 60000) % 60;
    if(mins < 10) { mins = "0" + mins; }
    var hours = Math.floor(ms / 3600000);
    if(hours < 10) { hours = "0" + hours; }

    return hours + ":" + mins + ":" + secs;
  }

  function round_with_2_decimals(number) {
    return Math.round(number * 100) / 100;
  }

  function readable_speed(speed) {
    return readable_size(speed) + "/s";
  }

  function readable_size(size) {
    if(size >= 0 && size < 1024) {
      return size + " B";
    }
    else if(size >= 1024 && size < 1048768) {
      return round_with_2_decimals(size/1024) + " KB";
    }
    else if(size >= 1048768 && size < 1073741824) {
      return round_with_2_decimals(size/1048768) + " MB";
    }
    else if(size >= 1073741824) {
      return round_with_2_decimals(size/1073741824) + " GB";
    }
  }

  /* Upload de Multiplos Arquivos */
  /* Tira o botão de dentro do form e faz com que ele submeta os formularios */
  function setup_progress_bars() {
    $("#user_files_forms form").submit();

    // Desabilita os botões
    $(".more-files a").unbind("click").hide();
    $("#upload_forms .buttons").unbind("click").hide();

    // Oculta os formulatios e mostra o progresso
    $("#user_files_forms form fieldset").hide();
    $("#user_files_forms form .progress_info").show();
    $("#user_files_forms form").each(function (i, form) {
      form.started_at = new Date()
      form.is_updating = false;
      var filename = /[^\\]*$/.exec($(form).find("li.file input").val());
      $(form).find(".progress_info .filename")[0].innerHTML = filename;
    });

    // Define o estado como uploading
    $("#user_files_forms form").attr("data-status", "uploading");
  }

  function update_status(form, callback) {
    if (form.is_updating) { callback('updating'); return; }
    form.is_updating = true;

    $.ajax({
      url: "/progress?X-Progress-ID=" + $(form).find(".file_fields input[type=hidden]").val(),
      dataType: "json",
      complete: function() { form.is_updating = false; },
      error: function (e) { callback('error', e); },
      success: function (data) {
        if (data) {
          if (data.state === 'uploading') {
            var updated_at = new Date();
            var percentage = Math.floor(data.received / data.size * 99) + "%";
            var elapsed_time = updated_at - form.started_at; // ms
            var speed = 0;
            var eta = 0;
            if (data.received < data.size) {
              speed = data.received * 1000 / elapsed_time; // bytes/s
              eta = (data.size - data.received) * 1000 / speed; // ms
            }

            $(form).find(".progress_info .uploaded").css('width', percentage);
            $(form).find(".progress_info .percentage").html(percentage);
            $(form).find(".progress_info .uptime .data").html(ms_to_hour_min_sec(elapsed_time));
            $(form).find(".progress_info .eta .data").html(ms_to_hour_min_sec(eta));
            $(form).find(".progress_info .speed .data").html(readable_speed(speed));
            $(form).find(".progress_info .data_amount .sent").html(readable_size(data.received));
            $(form).find(".progress_info .data_amount .total").html(readable_size(data.size));
          }
          callback(data.state, data);
        }
      }
    });
  }

  function reload() {
    location.reload(true);
  }

  function go_to_categorize() {
    var parameter = "";
    $("#user_files_forms form").each(function (i, form) {
      console.log($(form));
      if($(form).attr("data-status") === "success") {
        parameter += "files[]=" + $(form).attr("data-created_id") + "&";
      }
    });
    if (parameter.length > 0) {
      window.location = "/arquivos/categorizar?" + parameter;
    }
  }

  function tick() {
    var all_done = true;
    var all_errors = true;
    var forms = $("#user_files_forms form");

    function update_all(i) {
      if (i < forms.length) {
        update_status(forms[i], function(status) {
          if (status !== 'error') {
            all_errors = false;
          }

          if (status === 'done') {
            $(forms[i]).find(".progress_info .uploaded").width("100%");
            $(forms[i]).find(".progress_info .percentage").html("100%");
          } else {
            all_done = false;
          }

          update_all(i + 1);
        });
      }
      else {
        if (all_errors) {
          reload();
        }
        else if (all_done) {
          setTimeout(go_to_categorize, 4000);
        }
        else {
          setTimeout(tick, 500);
        }
      }
    }

    update_all(0);
  }

  $("#upload_forms").append($(".files_form .buttons").remove());
  $("#upload_forms .buttons").click(function () {
    setup_progress_bars();
    tick();
  });

  /* Salva o id do upload */
  var upload_id = $("#new_user_file .file_fields input[type=hidden]").val();
  var upload_action = $("#new_user_file").attr("action");

  /* Arruma o primero form */
  $("#new_user_file").attr("id", "new_user_file_0");
  $("#new_user_file_0").attr("target", "new_user_file_iframe_0");
  $("#new_user_file_0").attr("action", upload_action + "-0");
  $("#new_user_file_0").append("<iframe name=\"new_user_file_iframe_0\"></iframe>");
  $("#new_user_file_0 .file_fields input[type=hidden]").val(upload_id + "-0");
  var file_form_template = $("#new_user_file_0").clone();
  make_file_field($("#new_user_file_0 .file_fields .file input[type=file]"));
  make_checkbox($("#new_user_file_0 input[type=checkbox]"));
  var form_count = 1;

  /* Botão de mais arquivos */
  $(".more-files a").click(function () {
    var new_form = file_form_template.clone();
    $(new_form).attr("id", "new_user_file_" + form_count);
    $(new_form).attr("target", "new_user_file_iframe_" + form_count);
    $(new_form).attr("action", upload_action + "-" + form_count);
    $(new_form).children("iframe").attr("name", "new_user_file_iframe_" + form_count);
    $(new_form).find(".file_fields input[type=hidden]").val(upload_id + "-" + form_count);
    new_form[0].reset();
    $(new_form).find(".clear-on-focus").val($(new_form).find(".clear-on-focus").attr("title"));
    $(new_form).find(".public_field input[type=checkbox]").attr("id", "user_file_" + form_count + "_public");
    $(new_form).find(".public_field input[type=checkbox]").attr("name", "user_file_" + form_count + "[public]");
    $(new_form).find(".public_field label").attr("for", "user_file_" + form_count + "_public");
    $("#user_files_forms").append(new_form);

    make_file_field($(new_form).find(".file_fields .file input[type=file]"));
    make_checkbox($(new_form).find(".public_field input[type=checkbox]"));

    form_count++;
    return false; // Para não redirecionar
  });

  // Só executa dentro do iFrame
  if(window.parent != window) {
    var form_id = window.name.replace("new_user_file_iframe_", "");
    var form = $("#new_user_file_" + form_id, window.parent.document);
    if($(".file_fields .error").length > 0) {
      form.attr("data-status", "error");
    } else {
      form.attr("data-status", "success");
      form.attr("data-created_id", $(".sentenced_tags")[0].id.
                replace("files_", "").
                replace("_sentenced_tags", ""));
    }
  }

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
      var style = jQuery.parseJSON($("#style-list .thumbnail.index" +
                                     i.toString() + " .style").text());
      set_thumbnail_style("#style-list .thumbnail.index" + i.toString(), style);
    }
  }
  update_thumbnails();

  $("#style-customize ol li input[type=text]").
    bind('changed_style', function(e, style) {
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

    // TODO colocar o endereço real
    code_options = '<script src=\"http://www.smshare.com.br/caixa_download/template';
    if (args.length > 0) {
      code_options += '?' +
        args.map(function(a) {
          if (a.split('=')[0] !== attribute) { return a; } }).
        filter(function(a) { return a; }).join('&');
    }

    if (!is_default) {
      code_options = [code_options, [attribute, value].join('=')].
        join(args.length > 0 ? '&' : '?');
    }

    code_options += '\" type=\"text/javascript\"></script>';

    $("#code-area input[type=text]").attr('value', code_options);
  }

  $("#style-list .style-list-item").click(function(e) {
    var style = jQuery.parseJSON($(this).children(".thumbnail").children(".style").text());
    var style_id = $(this).attr("class").match(/id([a-f0-9]{24})/)[1];
    $("#style-customize ol li input[type=text]").trigger('changed_style', [style]);
    $("#style-list form #style_selected_style").attr("value", style_id);
    $("#style-list .style-list-item.selected").removeClass("selected");
    $(this).addClass("selected");

    code_box_set('estilo', style_id, $(this).hasClass("default"));

    /* Aplica o fundo padrão do estilo selecionado */
    $("#background-list .bg-list-item.id" + style.box_background_image).click();

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
    code_box_set('fundo', image_id, $(this).hasClass("default"));
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

  function done_compress(status, message) {
    if (status === 'failed') {
      force_hide_notifications();
      $(".alert").html(message);
      $(".notice").html("");
    }
    else if (status === 'completed') {
      $(".notice").html("Operação completa.");
    }
  }

  function update_compress_status() {
    var shall_continue = true;
    $.ajax({
      url: "compression_state",
      dataType: "json",
      success: function(data) {
        console.log(data);
        switch (data.status) {
        case "queued":
          $(".notice").html("Aguardando início da operação..."); break;
        case 'working':
          $(".notice").html(data.message); break;
        case 'no_job':
          shall_continue = false; break;
        case 'failed': case 'completed':
          done_compress(data.status, data.message);
          setTimeout(reload, 3000);
          shall_continue = false;
          break;
        }
        if (shall_continue) {
          $("#block_user_input").show();
          show_notifications(true);
          setTimeout(update_compress_status, 1000);
        }
        else {
          $("#block_user_input").hide();
          show_notifications(false);
        }
      }
    });
  }

  if (window.location.pathname.search(/manage/) >= 0) {
    update_compress_status();
  }

  /* Compressão em background */
  $("#compress").submit(function(e) {
    e.preventDefault();
    $.ajax({
      url: "compress",
      dataType: "json",
      data: $("#compress").serialize(),
      type: "POST",
      success: function(data) { update_compress_status(); },
      error: function(e) { console.log(e); }
    });
  });


  /* Descompressão em background */
  $(".actions_menu .decompress a").click(function() {
    $.ajax({
      url: "decompress",
      dataType: "json",
      data: $(".actions_menu .decompress form").serialize(),
      type: "POST",
      success: function(data) { update_compress_status(); },
      error: function(e) { console.log(e); }
    });
  });


  /* Carrega lista de estados dinamicamente */
  $("#user_profile_country").change(function () {
    $.ajax({
      url: "/users/states_for_country?country=" + $(this).val(),
      dataType: "json",
      type: "GET",
      success: function(data) {
        html = "<option value>Escolha</option>";
        for (var i = 0; i < data.length; i++) {
          html += "<option value=\"" + data[i][1] + "\">" + data[i][0] + "</option>";
        }
        $("#user_profile_state").html(html);
      },
      error: function(e) { console.log(e); }
    });
  });

  make_file_field($("#customize-container #bottom " + "#background-form input[type=file]"));

  /* Estilo do ComboBox */
  $("select").each(function() {
    var wrapper = $(document.createElement("span"));
    var button = $(document.createElement("span"));
    var value = $(document.createElement("span"));
    wrapper.addClass("custom-select");
    button.addClass("select-button");
    value.addClass("select-value");
    $(this).after(wrapper);
    $(this).detach();
    wrapper.append(value);
    wrapper.append(button);
    wrapper.append($(this));

    $(this).change(function() {
      value.text($(this).find("option:selected").text());
    });
    $(this).change();
  });

});


/* Faz pre-cache das imagens do cadastro */
cache_images("/images/layouts/botao-on.png");
