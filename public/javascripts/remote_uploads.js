function round2(n) {
  return Math.round(n * 100) / 100;
}

var units = {
  0: 'B',
  1: 'KB',
  2: 'MB',
  3: 'TB',
}

function human(n) {
  var unit = 0;
  while (n > 1024) {
    unit++;
    n /= 1024;
  }
  return round2(n).toString() + units[unit];
}

$(document).ready(function() {

  function track(id) {

    function loop() {
      setTimeout(function() {
        track(id);
      }, 1000);
    }
    
    $.get('/files/status/' + id, {}, function(data) {
      console.log(JSON.stringify(data));
      var status = data.ok;

      if (status.error) {
        inform_error(JSON.stringify(status.error));
        return;
      }

      if (status == 'nothing') {
        loop();
        return;
      }

      switch (status.phase) {
      case 'starting':
        inform_progress('Inciando transferência remota.')
        loop();
        break;
      case 'working':
        var round = round2(status.done/status.total * 100);
        var h_done = human(status.done);
        var h_total = human(status.total)
        inform_progress(h_done+'/'+h_total+': '+round+'%');
        loop();
        break;
      case 'done':
        inform_progress('Transferência remota completa.');
        $('#user_file_filename').prop('value', status.file.filename);
        $('#user_file_filepath').prop('value', status.file.filepath);
        $('#user_file_filesize').prop('value', status.file.filesize);
        $('#user_file_filetype').prop('value', status.file.filetype);
        setTimeout(function() {
          $.post($('#remote_form').prop('action'),
                 $('#remote_form').serialize(),
                 function(data) {
                    if (data.status == 'ok') {
                      window.location = '/arquivos/categorizar?files[]=' + data.id;
                    } else {
                      inform_error(data.reason);
                    }
                 });
        }, 3000);
        break;
      }
    }).error(function(e) {
      inform_error('Ocorreu um erro ao tentar obter status do upload remoto.'); 
    });
  }

  $('#remote_form .actions').click(function() {
    var url = encodeURIComponent($('#user_file_url').val());
    var description = $('#user_file_description').val();
    
    if (description == '' || description == $('#user_file_description').prop('title')) {
      return false;
    }

    $.get('/files/fetch/' + url+ '/' + description, function(data) {
      console.log("Fetch: " + JSON.stringify(data));
      if (!data.ok) {
        inform_error(data.error);
        return;
      }
      track(data.ok);
    }).error(function() {
      inform_error("O serviço de tranferência remota está indisponível");
    });

    return false;
  });

});
