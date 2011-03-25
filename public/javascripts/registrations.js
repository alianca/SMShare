$(document).ready(function() {
  /* Troca o fundo do botão em mouse over */
  $("#user_new #user_submit").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#user_new #user_submit").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });
  
  $("#user_new #user_fields input").focus(function () {
    $("#user_new #user_fields .inline-hints").hide(); /* Garante que não vai mostrar duas caixas */
    if(!$("#user_new #user_fields li").hasClass("error")) {
      $(this).siblings(".inline-hints").show();
    }
  });
  
  $("#user_new #user_fields input").blur(function () {
    $(this).siblings(".inline-hints").hide();
  });
  
  /* Disabilita o Botão até que o aceito termos seja aceita */
  $("#user_new #user_submit").attr("disabled", true);
  $("#user_new #user_submit").css("background", "url(/images/layouts/botao-disabled.png)")
  $("#user_new #terms_field #user_accepted_terms_input input[type=checkbox]").change(function () {
    if($(this).is(':checked')) {
      $("#user_new #user_submit").attr("disabled", false);
      $("#user_new #user_submit").css("background", "url(/images/layouts/botao-off.png)")
    } else {
      $("#user_new #user_submit").attr("disabled", true);
      $("#user_new #user_submit").css("background", "url(/images/layouts/botao-disabled.png)")
    }
    
  });
    
  /* Faz Validãções em Ajax */
  $("#user_new #user_fields input").blur(function () {
    /* Limpa os erros do campo antes de pedir os novos erros */
    $(this).parent().removeClass("error"); 
    $(this).parent().children(".inline-errors").remove();
    
    fields = this.name + "=" + this.value;
    if(this.name == "user[password_confirmation]") {
      fields += "&user[password]=" + $("#user_new #user_password_input input").val();
    }
    
    /* Faz a chamada Ajax */
    $.ajax({
      type: "POST",
      url: "/cadastro/valida_campo",
      data: fields,
      dataType: "json",
      success: function(result) {
        for(i in result) {
          for(j in result[i]) {
            $("#user_new #user_" + j + "_input").addClass("error");            
            $("#user_new #user_" + j + "_input").append("<p class=\"inline-errors\">" + result[i][j] + "</p>");
            $("#user_new #user_fields .inline-hints").hide();
          }
        }
      }      
    })
  });
});

var aaa = "";

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/layouts/botao-on.png");