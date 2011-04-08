$(document).ready(function() {

  $(".faq-item").each(function () {
    answer = $('p.answer', this);
    question = $('p.question', this);
    question.css("background", "url(/images/faq/fundo_seta_baixo.png) no-repeat");
    answer.hide();
    $(this).addClass("closed");
  });
  
  $(".faq-item p.question").bind('click', function (e) {
    item = $(this).parent();
    answer = $('p.answer', item);
    question = $(this);
      
    if (item.hasClass("open")) {
      question.css("background", "url(/images/faq/fundo_seta_baixo.png) no-repeat");
      answer.hide("fast");
      item.removeClass("open").addClass("closed");
    } else if (item.hasClass("closed")) {
      question.css("background", "url(/images/faq/fundo_seta_cima.png) no-repeat");
      answer.show("fast");
      item.removeClass("closed").addClass("open");
    }
    
    e.stopImmediatePropagation();
  });
  
});

