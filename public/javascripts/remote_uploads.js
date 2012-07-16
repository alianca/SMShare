$(document).ready(function() {

  function inform_error(error) {
    var message;
    switch (error) {
    case 'file_creation':
      message = 'Descrição não pode ficar em branco.';
      break;
    case 'user_not_found':
      message = 'Você deve estar logado para fazer isso.';
      break;
    case 'request_failed':
      message = 'O serviço de transferência não está disponível.';
    default:
      message = error;
      break;
    }
    $('.alert').html(message);
    show_notifications(false);
    setTimeout(function() { window.location = window.location; }, 3000);
  }

  function inform_progress(message) {
    $('.notice').html(message);
    show_notifications(true);
  }

  function track(id) {
    $.ajax({
      url: '/files/' + id,
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
      dataType: 'json',
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
