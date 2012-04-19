var timeout = null;
function setAnimation(i) {
  /* Menu */
  clearTimeout(timeout);

  $("#tv-menu li").removeClass("active");
  $("#tv-menu li:nth(" + i + ")").addClass("active");
  /* Slide */
  $(".slide").hide();
  $(".slide:nth(" + i + ")").show();

  timeout = setTimeout(function() {
    setAnimation((i + 1) % $("#tv-menu li").length);
  }, 6000);
}

$(document).ready(function() {
  $("#tv-menu li").each(function (i, element) {
    $(element).click(function(sender) {
      setAnimation(i);
    });
  });

  setAnimation(0);
});

/* Faz pre-cache das imagens da pagina inicial */
cache_images("/images/layouts/botao-on.png");