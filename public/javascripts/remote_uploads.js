$(document).ready(function() {

  function track(id) {
    $.ajax({
      url: id,
      dataType: 'JSON',
      error: function(data) {
        console.log(JSON.stringify(data));
      },
      success: function(data) {
        console.log(JSON.stringify(data));
        if (data.error) {
          inform_error(data.error);
        }
        else if (data.file_id) {
          inform_progress('Transferência remota completa.');
          setTimeout(function() {
            window.location = '/arquivos/categorizar?files[]=' + data.file_id;
          }, 3000);
        }
        else {
          if (data.status == 'working') {
            inform_progress(data.progress);
          }
          else if (data.status == 'queued') {
            inform_progress("Aguardando início da transferência.");
          }
          setTimeout(function() { track(id); }, 500);
        }
      }
    });
  }

  $('#remote_form .actions').click(function() {
    if ($('#user_file_description').val() ===
        $('#user_file_description').prop('title')) {
      return false;
    }
    $.ajax({
      url: $('#remote_form').prop('action'),
      data: $('#remote_form').serialize(),
      type: 'POST',
      dataType: 'JSON',
      error: function(data) {
        console.log(JSON.stringify(data));
      },
      success: function(data) {
        console.log(JSON.stringify(data));
        if (!data.id) {
          inform_error("O serviço de transfêrencia remota não está disponível.");
          return;
        }
        track(data.id);
      }
    });
    return false;
  });

});
