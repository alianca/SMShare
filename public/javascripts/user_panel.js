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
  
  $(".actions_menu .create a").click(function () {
    show_form("#new_folder");
  });
  
  $(".actions_menu .move a").click(function () {
    show_form("#move");
  });
  
  $(".actions_menu .rename a").click(function () {
    if (!($(this).hasClass("off"))) {
      show_rename();
    }
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
});

/* Faz pre-cache das imagens do cadastro */
$.cacheImages("/images/layouts/botao-on.png");
