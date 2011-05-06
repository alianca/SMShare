$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#search-header #search-button").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#search-header #search-button").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });
  
  /* marca as estrelas quando seleciona a nota, e seta o radio button invisivel */
  $("#file-container .comments #new-comment-form .rate-file .star").click(function() {
    var index = $(this).attr('class').match(/index(\d+)/)[1];
    $("#rate_" + index).attr('checked', 'checked');
    for (var i = 1; i <= 5; i++) {
      var element = $("#file-container .comments #new-comment-form .rate-file .star.index" + i);
      console.log(element);
      element.css('background', 'url(/images/search/icone-nota-' + (i<=index ? 'on' : 'off') + '.png) no-repeat');
    }
  });
  
  /* Atualiza o contador de caracteres restantes */
  $("#file-container .comments #new-comment-form #message").keyup(function() {
    var counter = $("#file-container .comments #new-comment-form .characters .character-counter");
    counter.text(280 - $(this).val().length);
  });
});
