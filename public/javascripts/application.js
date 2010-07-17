$(document).ready(function() {
  /* Escreve o texto do title no text_field, dessa maneira fazendo com que se o usuario desabilitou o javascript o text_field não vai conter lixo */
  $(".clear-on-focus").each(function () {
    if($(this).val() == "")
      $(this).val($(this).attr("title"));
  })
  
  /* Limpa quando o text_field ganhar o foco */
  $(".clear-on-focus").focus(function() {
    if($(this).val() == $(this).attr("title"))
      $(this).val("");
  });

  /* Retorna ao texto se o text_field está vazio quando ele perder o foco */
  $(".clear-on-focus").blur(function() {
    if($(this).val() == "")
      $(this).val($(this).attr("title"));
  });
  
  /* Troca o fundo do botão em mouse over */
  $("#search #search-button").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });
  
  /* Volta o fundo padrão quando perde o mouse over */
  $("#search #search-button").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });
  
  /* Menu dropdown */
  $("#header-menu > li").mouseover(function () {
    $("ul", this).show();
  });  
  $("#header-menu > li").mouseout(function () {
    $("ul", this).hide();
  });
});