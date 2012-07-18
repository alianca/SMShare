$(document).ready(function() {

  /* Troca o fundo do botão em mouse over */
  $('#folder_new #folder_submit').mouseover(function() {
    $(this).css('background', 'url(/images/layouts/botao-on.png)');
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $('#folder_new #folder_submit').mouseout(function() {
    $(this).css('background', 'url(/images/layouts/botao-off.png)');
  });

  /* Dropdown da sidebar */
  $('#sidebar li.menu').click(function(e) {
    if (!$(this).hasClass('no-dropdown') && this === e.target) {
      if ($(this).hasClass('active')) {
        $(this).children('ul.dropdown').hide('fast');
        $(this).removeClass('active');
      } else {
        $(this).children('ul.dropdown').show('fast');
        $(this).addClass('active');
      }
    }
    e.stopImmediatePropagation();
  });


  function show_form(name) {
    var show = $('#actions_forms :visible')[0] === undefined;
    hide_form();
    if (show) {
      $('#actions_forms ' + name).show();
      $('#form_placeholder').show();
    }
  }


  function show_rename() {
    var show = $('#actions_forms :visible')[0] === undefined;
    hide_form();
    if (show) {
      $('#actions_forms #rename').show();
      $('#rename_placeholder').show();
    }
  }

  function hide_form() {
    $('#actions_forms form').hide();
    $('#form_placeholder').hide();
    $('#rename_placeholder').hide();
  }

  var actions = {
    create: function() {
      show_form('#new_folder');
    },

    links: function() {
      window.location = '/arquivos/links?' +
        selected_ids().
        map(function(id){ return 'files[]=' + id; }).
        join('&');
    },

    move: function() {
      show_form('#move');
    },

    remove: function() {
      $.ajax({
        url: '/painel',
        data: $.param({
          files: selected_ids(),
          _method: 'DELETE',
          authenticity_token: $('input[name=authenticity_token]').val()
        }),
        type: 'POST',
        async: false,
        complete: function() {
          location.reload(true);
        }
      });
    },

    rename: function() {
      show_rename();
    },

    compress: function() {
      show_form('#compress');
    },

    decompress: function() {

    },

    properties: function() {

    }
  };

  $('.actions_menu a').click(function(e) {
    var value;
    if (!$(this).hasClass('off')) {
      value = actions[$(this).attr('action')]();
    }
    e.stopImmediatePropagation();
    e.preventDefault();
    return value || false;
  });


  function selected(init, interface) {
    var value = init;
    $('.file_list .select_file').each(function() {
      var f = interface[$(this).attr('checked') ? 'on' : 'off'];
      if (f) { value = f(value, $(this)); }
    });
    return value;
  }

  function selected_any() {
    return selected(false, {
      on: function() { return true; }
    });
  }

  function selected_all() {
    return selected(true, {
      off: function() { return false; }
    });
  }

  function selected_ids() {
    return selected([], {
      on: function(value, c) {
        value.push(c.val());
        return value;
      },
    });
  }

  function selected_paths() {
    return selected({}, {
      on: function(value, c) {
        var components = c.attr('filepath').split('/');
        value[c.attr('filename')] = components[components.length-1];
        return value;
      },
    });
  }

  var all_files = false;
  function toggle_all_files(value) {
    if (value === undefined) {
      value = !all_files;
    }
    all_files = value;
    $('input#all_files').attr('checked', all_files);
    $('input#all_files').change();
  }


  if($('input#all_files')) {
    $('input#all_files').click(function() {
      toggle_all_files();
      $('input.select_file').attr('checked', all_files);
      $('input.select_file').change();
    });
  }


  $('#move button').click(function(e) {
    selected_ids().forEach(function(id) {
      $('#move #user_file_files_' + id).attr('checked', true);
    });
    $.ajax({
      url: '/painel/move',
      type: 'POST',
      data: $('#move').serialize(),
      success: function() {
        console.log("ok");
      }
    });
    e.stopImmediatePropagation();
    e.preventDefault();
    return false;
  });


  function follow_status(id, action, callback) {
    $.ajax({
      url: '/files/' + action + '_status/' + id,
      dataType: 'JSON',
      type: 'GET',
      error: function(e) {
        inform_error(e.responseText);
      },
      success: function(data) {
        console.log(data);
        if (data.code === 'ok' && data.value.status !== 'error') {
          if (data.value.status === 'starting') {
            inform_progress('Iniciando ' + action);
          }
          else if (data.value.status === 'working') {
            inform_progress('Progresso da ' + action + ': '
                            + data.value.current + ' / ' + data.value.total
                            + (data.value.current / data.value.total * 100)
                            + '%');
          }

          if (data.value.status === 'done') {
            callback(data.value);
            inform_progress(action + ' completa.');
            return;
          }

          setTimeout(function() {
            follow_status(id, action, callback);
          }, 500);
        }
        else {
          inform_error(data.value);
        }
      }
    });
  }

  /* Compressão */
  $('#compress .actions').click(function(e) {
    var paths = selected_paths();

    $.ajax({
      url: '/files/compress/' + format_arch($('#user_file_filename').val()),
      data: $.param(paths),
      dataType: 'JSON',
      type: 'GET',
      error: function(e) {
        console.log(e.responseText);
      },
      success: function(data) {
        if (data.code === 'ok') {
          follow_status(data.value, 'compress', function(file) {
            ['name', 'type', 'size', 'path'].forEach(function(t) {
              $('#compress #user_file_file' + t).val(file[t]);
            });
            $('#compress #user_file_description').
              val(Object.keys(paths).join(', '));
            $('#compress').submit();
          });
        }
        else {
          console.log(data.value);
        }
      }
    });

    // Don't let the browser handle the event
    e.stopImmediatePropagation();
    e.preventDefault();
    return false;
  });


  $('.select_file').change(function() {
    /* Ajeita o formulário de rename */
    selected(null, {
      on : function(_, c) {
        $('#rename .field.hidden.' + c.val()).removeClass('hidden');
      },
      off: function(_, c) {
        $('#rename .field.' + c.val()).addClass('hidden');
      }
    });
    $('#rename_placeholder').height($('#rename').height() + 20);

    /* (des)Habilita os botões */
    if (selected_any()) {
      $('.actions_menu .need-files.off').removeClass('off');
    } else {
      $('.actions_menu .need-files').addClass('off');
      hide_form();
    }

    toggle_all_files(selected_all());
  });


});
