$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#search-header #search-button").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#search-header #search-button").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });
});