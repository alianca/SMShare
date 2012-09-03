$(document).ready(function() {

  function track(id) {

    function loop() {
      setTimeout(function() {
        track(id);
      }, 500);
    }
    
    $.get('/files/status/' + id, {}, function(data) {
      var status = data.ok;

      if (status.error) {
        inform_error(JSON.stringify(status.error));
        return;
      }

      switch (status.phase) {
      case 'starting':
        inform_progress('Inciando transferencia remota.')
        loop();
        break;
      case 'working':
        inform_progress(status.done + '/' + status.total + ' - '
          + status.done/status.total*100 + '%');
        loop();
        break;
      case 'done':
        inform_progress('Transferência remota completa.');
        $.post('/arquivos/remote', status.file, function(data) {
          setTimeout(function() {
            window.location = '/arquivos/categorizar?files[]=' + status.file.file_id;
          }, 3000);
        });
        break;
      }
    }).error(function() {
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
      console.dir(data);
      if (!data.ok) {
        inform_error("O serviço de transfêrencia remota não está disponível.");
        return;
      }
      track(data.ok);
    });

    return false;
  });

});
