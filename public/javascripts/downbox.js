/*
  Dynamically included:
  var options; // Downbox style
  global $ // JQuery
*/


function get_real_link(button) {
  var link = button.srcElement || button.target;
  while (link.localName != "a") {
    link = $(link).parent("a")[0];
  }
  return $(link);
}


function show_box(base, link, iframe, id, x, y) {
  var padding = parseInt(iframe.css('padding'));
  iframe.css({
    'left': x - (padding + 5),
    'top' : y - (padding + 10)
  });

  iframe.unbind('success');
  iframe.bind('success', function() {
    link.attr('url', iframe.attr('src'));
    iframe.hide();
  });

  iframe.attr('src', base + '/autorizacao/new?file_id=' + id + '&' + options);
}


function create_iframe() {
  $('body').prepend('<iframe id="downbox" />');

  var iframe = $('iframe#downbox');

  iframe.css({
    'display': 'none',
    'z-index': '8001',
    'position': 'absolute',
    'background': 'transparent',
    'border': 'none',
    'padding': '100px',
    'width': '392px',
    'height': '215px'
  });

  iframe.load(function() {
    var src = iframe.attr('src');

    if (/404/.test(src)) {
      // Download inválido
      window.location = src;
    }
    else {
      iframe.show();
    }
  });

  iframe.hover(
    /* in  */ function() {},
    /* out */ function() {
      iframe.hide();
    }
  );

  iframe.success = function(f) {
    iframe.success_h = f;
  };

  return iframe;
}


$(document).ready(function() {
  var iframe = create_iframe();

  $("a[rel~=\"smshare\"]").click(function(e) {
    e.stopImmediatePropagation();
    var url = get_real_link(e).attr('url');
    if (url) {
      window.location = url;
    }
    return false;
  });

  $("a[rel~=\"smshare\"]").hover(
    /* in  */ function(e) {
      e.stopImmediatePropagation();
      var link = get_real_link(e);

      if (iframe.is(':visible') || link.attr('url')) {
        // Se ja estiver aberto, ou ja tiver um link válido, não exibir a caixa.
        return false;
      }

      var file_id = link.attr('href').match(/arquivos\/([0-9a-f]{24})\/?$/)[1];
      var base = link.attr('href').match(/^([^\/]*)\//)[1];

      show_box(base, link, iframe, file_id, e.pageX, e.pageY);

      return false;
    },
    /* out */ function() {}
  );

});
