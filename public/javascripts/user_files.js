$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#user_file_submit, #links-container a.confirmar").mouseover(function () {
    $(this).css("background", "url(/images/user_files/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#user_file_submit, #links-container a.confirmar").mouseout(function () {
    $(this).css("background", "url(/images/user_files/botao-off.png)")
  });
  
  $("#categories-list input[type=checkbox]").change(function () {
    
    $("#user_file_categories_input input[value=" + this.value + "]").attr("checked", $(this).attr("checked"));
  });
  
  /* Altera o formato do link */
  $("#link-type-buttons-container input[name='link-type-option']").change(function () {
    field = $('#links-container #link-boxes-container .link-box .link-field');
    selected = $("input[name='link-type-option']:checked").val();
    if (selected == "type-html") {
      field.attr('value', '<a href=\"' + field.attr('url-text') + '\">Link</a>');
    } else if (selected == "type-forum") {
      field.attr('value', '[url=\"' + field.attr('url-text') + '\"]Link[/url]');
    } else if (selected == "type-sharebox") {
      field.attr('value', field.attr('url-text'));
    } else {
      field.attr('value', field.attr('url-text'));
    }
  });
});

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/user_files/botao-on.png");
