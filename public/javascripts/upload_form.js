$(document).ready(function() {
  /* Enviar mais arquivos */
  var i = 0;
  $("#more-files").click(function(e) {
    $("#files").append(
    "<div class=\"file\">\
       <div class=\"public_field\">\
         <input checked=\"checked\" class=\"files_public\" name=\"files[" + i + "][public]\" type=\"checkbox\" value=\"1\"/>\
         <label for=\"files_public\">Arquivo público (?)</label>\
       </div>\
       <div class=\"file_fields\">\
         <input class=\"files_file\" name=\"files[" + i + "][file]\" type=\"file\"/>\
         <input class=\"clear-on-focus\" class=\"files_description\" name=\"files[" + i + "][description]\" size=\"30\" placeholder=\"Digite uma descrição objetiva para seu arquivo.\" type=\"text\"/>\
       </div>\
     </div>");
    
    i++;
  });
  
  $("#more-files").click();
});
