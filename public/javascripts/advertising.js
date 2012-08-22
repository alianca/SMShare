$(document).ready(function() {
  $('#boxes .box, #boxes .links-box').hide();
  $('#boxes .preview').hide();

  $('#buttons div.button').click(function(e) {
    $('#buttons .button.active').removeClass('active');
    $(this).addClass('active');
    $('#boxes .box:visible').hide();
    $('#boxes .links-box:visible').hide();
    $('#boxes .' + $(this).prop('id')).fadeIn('fast')
  });
  $('#buttons #horizontal').click();

  $('#boxes .box').each(function() {
    var box = $(this);
    box.find('.mini').click(function(e) {
      box.find('.mini.active').removeClass('active');
      $(this).addClass('active');
      box.find('.preview:visible').hide();
      box.find('.preview.' + $(this).text()).fadeIn('fast');
    });
  });
  $('#boxes .box .mini.active').click();

  $('tr.reference_line').click(function() {
    var tag_name = $(this).find('td.reference div').text().split(' ')[0];
    var user_name = $('#user_name').text();
    var url = ("http://www.smshare.com.br/" +
               "?ref=" + user_name +
               "&ban=" + tag_name
              );
    $('input#url').val(url);

    $('tr.reference_line.selected').removeClass('selected');
    $(this).addClass('selected');
  });
  $('tr.reference_line')[0].click();
});
