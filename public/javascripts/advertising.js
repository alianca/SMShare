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

  function reset_url(field) {
    var user_name = $('#user_name').text();
    var tag_name = ($('tr.reference_line.selected td.reference div').
                    text().
                    split(' ')[0]);

    var url = ("http://www.smshare.com.br/"
               + "?ref=" + user_name
               + "&ban=" + tag_name);

    if (!field) {
      field = $('input#url');
    }

    var sel = field.parents('.box').find('.mini.active').text();
    var img = field.parent('.box').find('.preview.'+sel+' img').html();
    var tag = ('<a href="' + url + '">'
               + '<img src="' + img + '"></img>' +
               '</a>');
  }

  $('tr.reference_line').click(function() {

    $('input#url').each(function() {
      var sel = $(this).parents('.box').find('.mini.active').text();
      var img = $(this).parent('.box').find('.preview.'+sel+' img').html();
      var tag = ('<a href="' + url + '">'
                 + '<img src="' + img + '"></img>' +
                 '</a>');
      $(this).val(sel + '   ' + tag);
    });

    $('tr.reference_line.selected').removeClass('selected');
    $(this).addClass('selected');
  });
  $('tr.reference_line')[0].click();
});
