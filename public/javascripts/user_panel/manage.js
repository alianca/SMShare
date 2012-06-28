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


  function selected(what) {
    var result = (what ==   'any' ? false :
                 (what ==   'all' ?  true :
                 (what ==   'ids' ?    [] :
                 (what == 'paths' ?    {} :
                  undefined))));

    $('.file_list .select_file').each(function() {
      var checked = $(this).attr('checked');
      if (what == 'paths' && checked) {
        var components = $(this).attr('filepath').split('/');
        result[$(this).attr('filename')] = components[components.length-1];
      } else if (what == 'ids' && checked) {
        result.push($(this).val());
      } else if (what == 'any') {
        result = result || checked;
      } else if (what == 'all') {
        result = result && checked;
      }
    });

    return result;
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
      selected('ids').
      map(function(id){ return 'files[]=' + id; }).
      join('&');
    return false;
  });


  $('.destroy').click(function(e) {
    $.ajax({
      url: '/painel',
      data: $.param({
        files: selected('ids'),
        _method: 'DELETE',
        authenticity_token: $('input[name=authenticity_token]').val()
      }),
      type: 'POST',
      async: false,
      complete: function() { location.reload(true); }
    });
    return false;
  });


  /* Descompressão */
  $('.actions_menu .decompress a').click(function() {
    var files = [];
    var paths = selected('paths');
    Object.keys(paths).
      map(function(k){ return k + ':' + paths[k]; }).
      forEach(function(path) {
        $.ajax({
          url: '/files/' + path + '/decompress',
          dataType: 'JSON',
          type: 'GET',
          async: false,
          error: function(data) {
            console.log('Error: ', data.responseText);
          },
          success: function(data) {
            console.log(data);
            if (data.code == 'ok') {
              files = files.concat(data.value);
            } else {
              console.log(data.value);
            }
          }
        });
      });
  });


  /* Compressão */
  $('#compress .actions').click(function(e) {
    console.log(JSON.stringify(selected('paths')));
    $.ajax({
      url: '/files/compress/' + $('#user_file_filename').val(),
      data: $.param(selected('paths')),
      dataType: 'JSON',
      type: 'GET',
      error: console.log,
      success: function(data) {
        console.log(JSON.stringify(data));
        if (data.code == 'ok') {
          $('#compress #user_file_filename').val(data.value.name);
          $('#compress #user_file_filetype').val(data.value.type);
          $('#compress #user_file_filesize').val(data.value.size);
          $('#compress #user_file_filepath').val(data.value.path);
          $('#compress #user_file_description').val(Object.keys(selected('paths')).join(', '));
          $('#compress').submit();
        } else {
          console.log(data.value);
        }
      }
    });
    return false;
  });


  $('.file_list .select_file').change(function() {

    /* Ajeita o formulário de rename */
    if ($(this).attr('checked')) {
      $('#' + $(this).attr('value')).removeClass('hidden-field');
      $('#rename_placeholder').css('margin-bottom', $('#rename').height() + 27);
    } else {
      $('#' + $(this).attr('value')).addClass('hidden-field');
      $('#rename_placeholder').css('margin-bottom', $('#rename').height() + 27);
    }

    /* (des)Habilita os botões */
    if (selected('any')) {
      $('.actions_menu .need-files.off').removeClass('off');
    } else {
      $('.actions_menu .need-files').addClass('off');
      if ($('#actions_forms .need-files:visible')[0]) {
        $('#actions_forms').hide();
        $('#rename_placeholder').hide();
      }
    }

    toggle_all_files(selected('all'));
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
