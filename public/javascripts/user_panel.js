$(document).ready(function() {
  make_file_field($("#customize-container #bottom " + "#background-form input[type=file]"));

  /* Estilo do ComboBox */
  $("select").each(function() {
    var wrapper = $(document.createElement("span"));
    var button = $(document.createElement("span"));
    var value = $(document.createElement("span"));
    wrapper.addClass("custom-select");
    button.addClass("select-button");
    value.addClass("select-value");
    $(this).after(wrapper);
    $(this).detach();
    wrapper.append(value);
    wrapper.append(button);
    wrapper.append($(this));

    $(this).change(function() {
      value.text($(this).find("option:selected").text());
    });
    $(this).change();
  });

});


/* Faz pre-cache das imagens do cadastro */
cache_images("/images/layouts/botao-on.png");
