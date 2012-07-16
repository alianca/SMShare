$(document).ready(function() {

  /* Troca o fundo do botão em mouse over */
  $('#folder_new #folder_submit').mouseover(function() {
    $(this).css('background', 'url(/images/layouts/botao-on.png)');
  });


  /* Volta o fundo padrão quando perde o mouse over */
  $('#folder_new #folder_submit').mouseout(function() {
    $(this).css('background', 'url(/images/layouts/botao-off.png)');
  });


  function show_form(name) {
    if ($('#actions_forms ' + name + ':visible')[0]) {
      $('#actions_forms form').hide();
      $('#form_placeholder').hide();
    } else {
      $('#actions_forms form').hide();
      $('#actions_forms ' + name).show();
      $('#form_placeholder').show();
    }
  }


  function show_rename() {
    if ($('#actions_forms #rename:visible')[0]) {
      $('#actions_forms form').hide();
      $('#rename_placeholder').hide();
    } else {
      $('#actions_forms form').hide();
      $('#actions_forms #rename').show();
      $('#rename_placeholder').show();
    }
  }


  $('.actions_menu .create a').click(function(e) {
    show_form('#new_folder');
    e.stopImmediatePropagation();
  });


  $('.actions_menu .move a').click(function(e) {
    if (!($(this).hasClass('off'))) {
      show_form('#move');
    }
    e.stopImmediatePropagation();
  });


  $('.actions_menu .rename a').click(function(e) {
    if (!($(this).hasClass('off'))) {
        show_rename();
    }
    e.stopImmediatePropagation();
  });

  $('.actions_menu .compress a').click(function(e) {
    if (!($(this).hasClass('off'))) {
      show_form('#compress');
    }
    e.stopImmediatePropagation();
  });

  function selected(interface) {
    var value = interface.init();
    $('.file_list .select_file').each(function() {
      if ($(this).attr('checked')) {
        value = interface.on(value, $(this));
      } else {
        value = interface.off(value, $(this));
      }
    });
    return value;
  }

  function selected_any() {
    return selected({
      init: function() { return false; },
      on: function() { return true; },
      off: function(value) { return value; }
    });
  }

  function selected_all() {
    return selected({
      init: function() { return true; },
      on: function(value) { return value; },
      off: function() { return false; }
    });
  }

  function selected_ids() {
    return selected({
      init: function() { return []; },
      on: function(value, c) {
        value.push(c.val());
        return value;
      },
      off: function(value) { return value; }
    });
  }

  function selected_paths() {
    return selected({
      init: function() { return {}; },
      on: function(value, c) {
        var components = c.attr('filepath').split('/');
        value[c.attr('filename')] = components[components.length-1];
        return value;
      },
      off: function(value) { return value; }
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


  $('.links_button').click(function(e) {
    window.location = '/arquivos/links?' +
      selected_ids().
      map(function(id){ return 'files[]=' + id; }).
      join('&');
    return false;
  });


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
  });


  $('.destroy').click(function(e) {
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
    return false;
  });

  function get_values(object) {
    return Object.keys(object).map(function(k){ return object[k]; });
  }

  function decompress(files, callback, acc) {
    acc = acc || []; // Default parameter

    if (files.length === 0) {
      callback(acc);
      return;
    }

    $.ajax({
      url: '/files/' + files[0] + '/decompress',
      type: 'GET',
      dataType: 'JSON',
      error: function(data) {
        console.log(data.responseText);
      },
      success: function(data) {
        if (data.code === 'ok') {
          follow_status(data.value, 'decompress', function(data) {
            var dec_files = JSON.parse(data.files.replace('\"', '"')).
              map(function(f) {
                return {
                  filename: f.name,
                  filepath: f.path,
                  filesize: f.size,
                  filetype: f.type,
                  description: "Arquivo descompactado.",
                  public: true
                };
              });

            setTimeout(function() {
              decompress(files.slice(1, files.length), callback,
                         acc.concat(dec_files));
            }, 100);
          });
        }
      }
    });
  }

  $('.actions_menu .decompress a').click(function() {
    decompress(get_values(selected_paths()), function(data) {
      $('#multi_form #files').val(JSON.stringify(data));
      $('#multi_form').submit();
    });
  });

  function format_arch(name) {
    var components = name.split('.');
    var ext = components[components.length - 1];
    if (['zip', 'jar', 'pkg', 'egg', 'cbz'].indexOf(ext) < 0) {
      return name + '.zip';
    }
    return name;
  }

  function follow_status(id, action, callback) {
    $.ajax({
      url: '/files/' + action + '_status/' + id,
      dataType: 'JSON',
      type: 'GET',
      error: function(e) {
        console.log(e.responseText);
      },
      success: function(data) {
        console.log(data);
        if (data.code === 'ok' && data.value.status !== 'error') {
          if (data.value.status === 'starting') {
            console.log('Starting to', action, data.value.total, 'files.');
          }
          else if (data.value.status === 'working') {
            console.log(action + 'ed',
                        data.value.current, 'of',
                        data.value.total);
          }

          if (data.value.status === 'done') {
            callback(data.value);
            console.log('Done', action + 'ing:', JSON.stringify(data.value))
            return;
          }

          setTimeout(function() {
            follow_status(id, action, callback);
          }, 500);
        }
        else {
          console.log(data.value);
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
    return false;
  });


  $('.file_list .select_file').change(function() {

    /* Ajeita o formulário de rename */
    if ($(this).attr('checked')) {
      $('#' + $(this).attr('value')).removeClass('hidden-field');
      $('#rename_placeholder').
        css('margin-bottom', $('#rename').height() + 27);
    } else {
      $('#' + $(this).attr('value')).addClass('hidden-field');
      $('#rename_placeholder').
        css('margin-bottom', $('#rename').height() + 27);
    }

    /* (des)Habilita os botões */
    if (selected_any()) {
      $('.actions_menu .need-files.off').removeClass('off');
    } else {
      $('.actions_menu .need-files').addClass('off');
      if ($('#actions_forms .need-files:visible')[0]) {
        $('#actions_forms').hide();
        $('#rename_placeholder').hide();
      }
    }

    toggle_all_files(selected_all());
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

});
