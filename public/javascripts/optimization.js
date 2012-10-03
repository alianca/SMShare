$(document).ready(function() {

  $(".item").each(function() {
    var item = $(this);

    item.find(".item-name").click(function() {
      var bar = $(this);

      item.find("p").toggle("fast");
      bar.toggleClass("closed");
    });

    item.find("p").hide();
    item.find(".item-name").each(function() {
      $(this).addClass("closed");
    });
  });

});
