$(document).ready(function() {
  /* Enviar mais arquivos */
  $("#more-files").click(function(e) {
    var new_field = $(".single-file.hidden").clone(true);
    new_field.removeClass("hidden");
    
    var count = $("#user_files_count");
    count.attr("value", parseInt(count.attr("value"))+1);
    
    var fields = ["public", "file", "description"];
    
    for (var i = 0; i < 3; i++) {
      var field = new_field.find("#user_files_user_file_" + fields[i]);
      field.attr("name", "user_files[user_file" + count.attr("value") + "][" + fields[i] + "]");
      console.log(field.attr("name"));
    }
    
    $(".all-files").append(new_field[0]);
  });
  
  $("#more-files").click();
});
