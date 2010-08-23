$(document).ready(function() {
  /* TV */
  $("#tv-menu li").each(function (i, element) {
    $(element).click(function (sender) {
      /* Menu */
      $("#tv-menu li").removeClass("active");
      $("#tv-menu li:nth(" + i + ")").addClass("active");
      /* Slide */
      $(".slide").hide();
      $(".slide:nth(" + i + ")").show();
    });
  });
});

/* Faz pre-cache das imagens da pagina inicial */
$.cacheImages("/images/layouts/botao-on.png");