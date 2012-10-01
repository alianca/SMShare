$(document).ready(function() {

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


  /* Upload de Multiplos Arquivos
   * Tira o botão de dentro do form e faz com que ele submeta
   * os formularios
   */
  function setup_progress_bars() {
    // Desabilita os botões
    $(".more-files a").unbind("click").hide();
    $("#upload_forms .actions").unbind("click").hide();

    // Oculta os formulatios e mostra o progresso
    $("#user_files_forms form fieldset").hide();
    $("#user_files_forms form .progress_info").show();
    $("#user_files_forms form").each(function (i, form) {
      form.started_at = new Date();
      var filename = /[^\\]*$/.exec($(form).find("li.file input").
        val());
      $(form).find(".progress_info .filename")[0].innerHTML =
        filename;
    });
  }


  function reload() {
    location.reload(true);
  }


  function go_to_categorize(forms) {
    window.location = '/arquivos/categorizar?' +
      forms.map(function(form) {
        console.log($(form).attr('data-created_id'));
        var id = $(form).attr('data-created_id');
        if(id) {
          return 'files[]=' + id;
        } else {
          return '';
        }
      }).join('&');
  }

  var FILE="";//"69.64.50.217";
  function update_status(form, done) {
    var id = $(form).find(".file_fields #X-Progress-ID").val();
    $.ajax({
      url: FILE+"/progress?X-Progress-ID=" + id,
      dataType: "json",
      error: function(e) { status = 'error' },
      success: function(data) {
        console.log(JSON.stringify(data));
        switch (data.state) {
        case 'uploading':
          var updated_at = new Date();
          var percentage =
            Math.floor(data.received / data.size * 100) + "%";
          var elapsed_time = updated_at - form.started_at; // ms
          var speed = 0;
          var eta = 0;

          if (data.received < data.size) {
            speed = data.received * 1000 / elapsed_time; // bytes/s
            eta = (data.size - data.received) * 1000 / speed; // ms
          }

          $(form).find(".progress_info .uploaded").
            width(percentage);
          $(form).find(".progress_info .percentage").
            html(percentage);
          $(form).find(".progress_info .uptime .data").
            html(ms_to_hour_min_sec(elapsed_time));
          $(form).find(".progress_info .eta .data").
            html(ms_to_hour_min_sec(eta));
          $(form).find(".progress_info .speed .data").
            html(readable_speed(speed));
          $(form).find(".progress_info .data_amount .sent").
            html(readable_size(data.received));
          $(form).find(".progress_info .data_amount .total").
            html(readable_size(data.size));
          break;
        case 'done':
          $(form).find(".progress_info .uploaded").width('100%');
          $(form).find(".progress_info .percentage").html('100%');
          $(form).find('.progress_info .filename').
            append(' - Completo');
          break;
        case 'error':
          $(form).find('.progress_info .filename').
            append(' - ' + JSON.stringify(data));
          break;
        }
        done(data.state);
      }
    });
  }


  function async_for_each(list, acc, each, done) {
    if (!list || !list[0]) {
      done(acc);
      return;
    }
    each(acc, list[0], function(next) {
      async_for_each(list.slice(1), next, each, done);
    });
  }


  function tick(forms, completed) {
    if (!completed) {
      completed = {
        done: [],
        error: [],
      };
    }

    if (forms.length === 0) {
      setTimeout(function() {
        go_to_categorize(completed.done);
      }, 4000);
      return;
    }

    async_for_each(forms, [],
      function(uploading, form, next) {
        update_status(form, function(status) {
          if (status === 'starting' || status === 'uploading') {
            uploading.push(form);
          } else if (status in completed) {
            completed[status].push(form);
          }
          next(uploading);
        });
      },
      function(uploading) {
        setTimeout(function() {
          tick(uploading, completed);
        }, 200);
      }
    );
  }

  /* Inicia os uploads */
  function send_files() {
    var forms = [];
    $('#user_files_forms form').each(function(i, form) {
      $.ajax({
        url: $(form).attr('action'),
        type: 'POST',
        data: new FormData(form),
        cache: false,
        dataType: 'JSON',
        contentType: false,
        processData: false,
        success: function(data) {
          if (data.status === 'ok') {
            $(form).attr('data-created_id', data.id);
          }
        }
      });
      forms.push(form);
    });
    tick(forms);
  }

  $('#upload_forms').append($('.files_form .actions').remove());
  $('#upload_forms .actions').click(function(e) {
    e.stopImmediatePropagation();
    setup_progress_bars();
    send_files();
    return false;
  });


  /* Salva o id do upload */
  var upload_id =
    $('#new_user_file .file_fields #X-Progress-ID').val();
  var upload_action = $('#new_user_file').attr('action');


  /* Arruma o primero form */
  $('#new_user_file').attr('id', 'new_user_file_0');
  $('#new_user_file_0').attr('target', 'new_user_file_iframe_0');
  $('#new_user_file_0').attr('action', upload_action + '-0');
  $('#new_user_file_0').
    append('<iframe name="new_user_file_iframe_0"></iframe>');
  $('#new_user_file_0 .file_fields #X-Progress-ID').
    val(upload_id + '-0');
  var file_form_template = $('#new_user_file_0').clone();
  make_file_field(
    $('#new_user_file_0 .file_fields .file input[type=file]'));
  make_checkbox($('#new_user_file_0 input[type=checkbox]'));
  var form_count = 1;


  /* Botão de mais arquivos */
  $('.more-files a').click(function () {
    var new_form = file_form_template.clone();
    $(new_form).attr('id', 'new_user_file_' + form_count);
    $(new_form).attr('target', 'new_user_file_iframe_' +
      form_count);
    $(new_form).attr('action', upload_action + '-' + form_count);
    $(new_form).children('iframe').
      attr('name', 'new_user_file_iframe_' + form_count);
    $(new_form).find('.file_fields #X-Progress-ID').
      val(upload_id + '-' + form_count);
    new_form[0].reset();
    $(new_form).find('.clear-on-focus').val($(new_form).
      find('.clear-on-focus').attr('title'));
    $(new_form).find('.public_field input[type=checkbox]').
      attr('id', 'user_file_' + form_count + '_public');
    $(new_form).find('.public_field input[type=checkbox]').
      attr('name', 'user_file_' + form_count + '[public]');
    $(new_form).find('.public_field label').
      attr('for', 'user_file_' + form_count + '_public');
    $('#user_files_forms').append(new_form);

    make_file_field($(new_form).
      find('.file_fields .file input[type=file]'));
    make_checkbox($(new_form).
      find('.public_field input[type=checkbox]'));

    form_count++;
    return false; // Para não redirecionar
  });

});
