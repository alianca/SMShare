$(document).ready(function() {

  $('#remote_form .actions').click(function() {
    $.ajax({
      url: '../remote_upload_store',
      data: 'url=' + $('#user_file_url').val().split('?')[0],
      dataType: 'json',
      error: function(data) { alert(JSON.stringify(data)); },
      success: function(data) {
        console.log(JSON.stringify(data));

        if (data.status == 'error') {
          alert('Error: ' + data.reason);
          return;
        }

        ['path', 'name', 'type', 'size'].forEach(function(param){
          $('#user_file_file' + param).val(data[param]);
        });

        console.log('Will submit now...');

        $('#remote_form').submit();
      }
    });
    return false;
  });

});
