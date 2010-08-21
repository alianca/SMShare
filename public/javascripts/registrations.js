$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#user_new #user_submit").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#user_new #user_submit").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });  
});