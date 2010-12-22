$(document).ready(function() {
  if($("input#all_files")) {
    $("input#all_files").live("click", function() {
      $("input.select_file").attr("checked", $("input#all_files").attr("checked"));
    });
  }
});