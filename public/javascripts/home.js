$(document).ready(function() {
  /* TV */
  $("#tv-menu a").each(function (i, element) {
    $(element).click(function (sender) {
      /* Menu */
      $("#tv-menu a li").removeClass("active");
      $("#tv-menu a:nth(" + i + ") li").addClass("active");
      /* Slide */
      $(".slide").hide();
      $(".slide:nth(" + i + ")").show();
    });
  });
  
});