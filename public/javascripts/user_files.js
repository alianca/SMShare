$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#user_file_submit").mouseover(function () {
    $(this).css("background", "url(/images/user_files/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#user_file_submit").mouseout(function () {
    $(this).css("background", "url(/images/user_files/botao-off.png)")
  });
  
  $("#categories-list input[type=checkbox]").change(function () {
    
    $("#user_file_categories_input input[value=" + this.value + "]").attr("checked", $(this).attr("checked"));
  });
});

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/user_files/botao-on.png");