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
      show_form('#remove');
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
    $('#move').submit();
  });


  $('#remove .actions').click(function(e) {
    e.stopImmediatePropagation();
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

  $('.file_list tr.item td').click(function(e) {
    if ($(e.target).is('a')) {
      e.stopPropagation();
    } else if ($(e.target).is('td')) {
      e.stopImmediatePropagation();
      var cb = $(this).parents('tr').find('.select_file');
      cb.prop('checked', !cb.prop('checked'));
      cb.change();
      return false;
    }
    return true;
  });

  function follow_status(id, callback) {
    function loop() {
      setTimeout(function(){
        follow_status(id, callback);
      }, 500);
    }
    $.get('/files/status/' + id, function(data) {
      console.log(JSON.stringify(data));
      if (data.error) {
        inform_error(data.error);
        return;
      }
      callback(data.ok);
      if (data.ok.phase != 'done') {
        loop();
      }
    });
  }

  function update_rename_form() {
    selected(null, {
      on : function(_, c) {
        $('#rename .field.hidden.' + c.val()).removeClass('hidden');
      },
      off: function(_, c) {
        $('#rename .field.' + c.val()).addClass('hidden');
      }
    });
    $('#rename_placeholder').height($('#rename').height() + 20);
  }

  function update_toolbar_buttons() {
    if (selected_any()) {
      $('.actions_menu .need-files.off').removeClass('off');
    } else {
      $('.actions_menu .need-files').addClass('off');
      hide_form();
    }
  }


  $('.select_file').change(function() {
    update_rename_form();
    update_toolbar_buttons();
    toggle_all_files(selected_all());
    if ($(this).prop('checked')) {
        $(this).parent('td').parent('tr').find('td').addClass('selected');
    } else {
        $(this).parent('td').parent('tr').find('td').removeClass('selected');
    }
  });
  // Update page in case of coming back with saved state
  $('.select_file').change();


  $('#compress .actions').click(function(e) {
    e.stopImmediatePropagation();
    e.preventDefault();
    var args = $('#compress #user_file_filename').prop('value');
    var paths = selected_paths();
    for (var k in paths) {
      args += '/' + k + '::' + paths[k];
    }
    $.get('/files/compress/' + args, [], function(data) {
      follow_status(data.ok, function(status) {
        switch (status.phase) {
          case 'starting':
            inform_progress('Iniciando compactação.');
            break;
          case 'working':
            inform_progress('Compactando ' + status.current);
            break;
          case 'done':
            inform_progress('Compactação completa.');
            $('#compress #user_file_filename').prop('value', status.filename);
            $('#compress #user_file_filesize').prop('value', status.filesize);
            $('#compress #user_file_filetype').prop('value', status.filetype);
            $('#compress #user_file_filepath').prop('value', status.filepath);
            $.post($('#compress').prop('action'),
                   $('#compress').serialize(),
                   function(data) {
                     window.location = '/arquivos/categorizar?files[]='+data.id;
                   });
            break;
        }
      });
    }).error(function() {
      inform_error(
        'O serviço de compactação de arquivos está temporariamente indisponível.'
      );
    });

    return false;
  });

});
