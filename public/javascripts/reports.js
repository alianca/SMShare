$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#user_panel-container form input[type=submit]").mouseover(function () {
    $(this).css("background", "url(/images/user_files/botao-rename-on.png) no-repeat")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#user_panel-container form input[type=submit]").mouseout(function () {
    $(this).css("background", "url(/images/user_files/botao-rename-off.png) no-repeat")
  });
});

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/user_files/botao-rename-on.png");