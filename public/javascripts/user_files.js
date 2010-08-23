$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#new_user_file #user_file_submit").mouseover(function () {
    $(this).css("background", "url(/images/user_files/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#new_user_file #user_file_submit").mouseout(function () {
    $(this).css("background", "url(/images/user_files/botao-off.png)")
  });  
});
