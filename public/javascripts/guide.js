$(document).ready(function() {

  $('li.guide-item').each(function() {
    title = $('div.title', this);
    text = $('p.text', this);
    arrow = $('.arrow', title);
    arrow.css('background', 'url(/images/guia/arrow_down.png) no-repeat');
    text.hide();
    $(this).addClass('closed');
  });
  
  $('li.guide-item div.title').click(function() {
    item = $(this).parent();
    title = $(this);
    arrow = $('.arrow', title);
    text = $('p.text', item);
    
    if (item.hasClass("open")) {
      text.hide('fast');
      arrow.css('background', 'url(/images/guia/arrow_down.png) no-repeat');
      item.removeClass('open').addClass('closed');
    } else if (item.hasClass('closed')) {
      text.show('fast');
      arrow.css('background', 'url(/images/guia/arrow_up.png) no-repeat');
      item.removeClass('closed').addClass('open');
    }
    
  });

});

