/*
  Dynamically included:
  var options; // Downbox style
  global $ // JQuery
*/


function get_real_link(link) {
  while (link.localName != 'a') {
    link = $(link).parent('a')[0];
  }
  return $(link);
}


function show_box(iframe, x, y) {
  var padding = parseInt(iframe.css('padding'));
  iframe.css({
    'left': Math.max(x - iframe.width() / 2 - padding, -padding),
    'top' : Math.max(y - iframe.height() / 2 - padding, -padding)
  });

  iframe.show();
}


function create_iframe(link) {

  var file_id = link.attr('href').match(/arquivos\/([0-9a-f]{24})\/?$/)[1];
  var base = link.attr('href').match(/^((http:\/\/)?[^\/]*)\//)[1];
  var url = base + '/autorizacao/new?file_id=' + file_id + '&' + options;

  var iframe = $('<iframe '
                 + 'id="downbox" '
                 + 'class="' + file_id + '" '
                 + 'src="' + url + '" '
                 + '/>');

  $('body').prepend(iframe);

  iframe.css({
    'display': 'none',
    'z-index': '8001',
    'position': 'absolute',
    'background': 'transparent',
    'border': 'none',
    'padding': '30px',
    'width': '392px',
    'height': '215px'
  });

  iframe.hover(
    /* in  */ function() {},
    /* out */ function() {
      iframe.hide();
    }
  );

  iframe.ready(function() {
    console.log(iframe);
  });

  return iframe;
}


$(document).ready(function() {
  $('a[rel~="smshare"]').each(function() {

    var link = get_real_link(this);
    var iframe = create_iframe(link);

    link.click(function(e) {
      // Ignore clicks
      e.stopImmediatePropagation();
      return false;
    });

    link.hover(
      /* in  */ function(e) {
        e.stopImmediatePropagation();

        if (iframe.is(':visible')) {
          return false; // Não abrir duas vezes
        }

        show_box(iframe, e.pageX, e.pageY);

        return false;
      },
      /* out */ function() {}
    );

  });
});
