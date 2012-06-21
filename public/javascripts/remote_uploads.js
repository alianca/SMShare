$(document).ready(function() {

  $('#remote_form .actions').click(function() {

    if ($('#user_file_description').val() ===
        $('#user_file_description').prop('title')) {
      return false;
    }

    $.ajax({
      url: '../files/fetch?url=' + $('#user_file_url').val().split('?')[0],
      dataType: 'json',
      error: function(data) {
        console.log(JSON.stringify(data));
      },
      success: function(data) {
        console.log(JSON.stringify(data));

        if (data.status == 'error') {
          window.location = window.location;
          return false;
        }

        ['path', 'name', 'type', 'size'].forEach(function(param) {
          $('#user_file_file' + param).val(data[param]);
        });

        $('#remote_form').submit();
      }
    });
    return false;
  });

});
