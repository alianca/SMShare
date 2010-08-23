$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#new_user_file #user_file_submit").mouseover(function () {
    $(this).css("background", "url(/images/user_files/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#new_user_file #user_file_submit").mouseout(function () {
    $(this).css("background", "url(/images/user_files/botao-off.png)")
  });
  
  /* Arruma o file_field no Firefox */
  if($.browser.mozilla) {
      $("#new_user_file #user_file_file").attr("size", 46);
      $("#new_user_file #user_file_file_input").css("padding", "7px 8px");
      $("#new_user_file #user_file_file_input").css("background", "url(/images/user_files/campo.png)");
  }
});

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/user_files/botao-on.png");