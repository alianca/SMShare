$(document).ready(function() {
  if($("input#all_files")) {
    $("input#all_files").live("click", function() {
      $("input.select_file").attr("checked", $("input#all_files").attr("checked"));
      $("input.select_file").each(function() {
        $(this).change();
      });
    });
  }
  
  /* Troca o fundo do botão em mouse over */
  $("#folder_new #folder_submit").mouseover(function () {
    $(this).css("background", "url(/images/layouts/botao-on.png)")
  });

  /* Volta o fundo padrão quando perde o mouse over */
  $("#folder_new #folder_submit").mouseout(function () {
    $(this).css("background", "url(/images/layouts/botao-off.png)")
  });
  
  function show_form(name) {
    if($("#actions_forms " + name + ":visible")[0]) {
      $("#actions_forms form").hide();
      $("#form_placeholder").hide();
    } else {
      $("#actions_forms form").hide();
      $("#actions_forms " + name).show();
      $("#form_placeholder").show();
    }
  }
  
  function show_rename() {
    if ($("#actions_forms #rename:visible")[0]) {
      $("#actions_forms form").hide();
      $("#rename_placeholder").hide();
    } else {
      $("#actions_forms form").hide();
      $("#actions_forms #rename").show();
      $("#rename_placeholder").show();
    }
  }
  
  $(".actions_menu .create a").click(function (e) {
    show_form("#new_folder");
    e.stopImmediatePropagation();
  });
  
  $(".actions_menu .move a").click(function (e) {
    show_form("#move");
    e.stopImmediatePropagation();
  });
  
  $(".actions_menu .rename a").click(function (e) {
    if (!($(this).hasClass("off"))) {
      show_rename();
    }
    e.stopImmediatePropagation();
  });
  
  /* Copia a seleção de arquivos da tabela para a lista oculta */
  $(".file_list .select_file").change(function () {
    $("#actions_forms .hidden_file_list input[value=" + this.value + "]").attr("checked", $(this).attr("checked"));
    
    if ($(this).attr("checked")) {
      $("#" + this.value).removeClass("hidden-field");
      $("#rename_placeholder").css("margin-bottom", $("#rename").height() + 27);
    } else {
      $("#" + this.value).addClass("hidden-field");
      $("#rename_placeholder").css("margin-bottom", $("#rename").height() + 27);
    }
    
    var has_selected = false;
    $("#actions_forms .hidden_file_list input[type=checkbox]").each(function() {
      if ($(this).attr("checked")) {
        has_selected = true;
      }
    });
    
    if (has_selected) {
      $(".actions_menu .rename a").removeClass("off");
    } else {
      $(".actions_menu .rename a").addClass("off");
      if ($("#actions_forms #rename:visible")[0]) {
        $("#actions_forms form").hide();
        $("#rename_placeholder").hide();
      }
    }
    
  });
  
  /* Dropdown da sidebar */
  $("#sidebar li.menu").click(function(e) {
    if (!$(this).hasClass("no-dropdown") && this == e.target) {
      if ($(this).hasClass("active")) {
        $(this).children("ul.dropdown").hide("fast");
        $(this).removeClass("active");
      } else {
        $(this).children("ul.dropdown").show("fast");
        $(this).addClass("active");
      }
    }
    e.stopImmediatePropagation();
  });
  
  /* Upload de Multiplos Arquivos */
  /* Tira o botão de dentro do form e faz com que ele submeta os formularios */
  $("#upload_forms").append($(".files_form .buttons").remove());
  $("#upload_forms .buttons").click(function () {
    $("#user_files_forms form").submit();    
    // TODO Travar o botão e o mais arquivos
    
    $("#user_files_forms form").attr("data-status", "uploading");
    
    /* Função que verifica o estado dos downloads e redireciona no final */
    status_interval = setInterval(function () {
      not_done = false;      
      $("#user_files_forms form").each(function (i, form) { 
        not_done = not_done || $(form).attr("data-status") == "uploading"        
      });    
      
      if(!not_done) {
        errors = false;
        success = false;
        
        $("#user_files_forms form").each(function (i, form) {           
          errors = errors || $(form).attr("data-status") == "error"
          success = success || $(form).attr("data-status") == "success"
        });
        
        if(errors && !success) { // Só errors
          window.location = window.location; // Reload
        } else {
          parameter = ""
          $("#user_files_forms form").each(function (i, form) {           
            if($(form).attr("data-status") == "success") {
              parameter += "files[]=" + $(form).attr("data-created_id") + "&"
            }
          });          
          
          window.location = "/arquivos/categorizar?" + parameter; // Vai para o categorizar
        }
                
        clearInterval(status_interval);
      }      
    }, 100);    
  });
  
  /* Arruma o primero form */
  $("#new_user_file").attr("id", "new_user_file_0");
  $("#new_user_file_0").attr("target", "new_user_file_iframe_0");
  $("#new_user_file_0").append("<iframe name=\"new_user_file_iframe_0\"></iframe>")
  form_count = 1;
  
  /* Botão de mais arquivos */
  $(".more-files a").click(function () {
    new_form = $("#new_user_file_0").clone();
    $(new_form).attr("id", "new_user_file_" + form_count);  
    $(new_form).attr("target", "new_user_file_iframe_" + form_count);  
    $(new_form).children("iframe").attr("name", "new_user_file_iframe_" + form_count);
    new_form[0].reset();
    $(new_form).find(".clear-on-focus").val($(new_form).find(".clear-on-focus").attr("title"));
    $("#user_files_forms").append(new_form);    
    
    form_count++;
    return false; // Para não redirecionar
  });
  
  // Só executa dentro do iFrame
  try {
    if(window.parent != window) {      
      form_id = window.name.replace("new_user_file_iframe_", "");
      form = $("#new_user_file_" + form_id, window.parent.document);
      if($(".file_fields .error").length > 0) {
        form.attr("data-status", "error");
      } else {
        form.attr("data-status", "success");
        form.attr("data-created_id", $(".sentenced_tags")[0].id.replace("files_", "").replace("_sentenced_tags", ""));
      }
    }    
  } catch (Exception) {}
});

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/layouts/botao-on.png");
