$(document).ready(function() {

  function track(id) {
    $.ajax({
      url: '/files/' + id,
      dataType: 'JSON',
      error: function(data) {
        console.log(JSON.stringify(data));
      },
      success: function(data) {
        console.log(JSON.stringify(data));
        switch (data.status) {
        case 'completed':
          //window.location = '/arquivos/categorizar?files[]=' + data.file_id;
          break;
        case 'failed':
          console.log('Erro:', data.error);
          window.location = window.location;
          break;
        case 'working':
          console.log('Progress:', data.message);
        default:
          setTimeout(function() { track(id); }, 500);
        }
      }
    });
  }

  $('#remote_form .actions').click(function() {
    if ($('#user_file_description').val() === $('#user_file_description').prop('title')) {
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
          console.log('Error.');
          return;
        }
        track(data.id);
      }
    });
    return false;
  });

});
