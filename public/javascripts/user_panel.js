$(document).ready(function() {

  /* Carrega lista de estados dinamicamente */
  $("#user_profile_country").change(function () {
    $.ajax({
      url: "/users/states_for_country?country=" + $(this).val(),
      dataType: "json",
      type: "GET",
      success: function(data) {
        html = "<option value>Escolha</option>"
        html += data.map(function(d) {
          return '<option value"' + d[1] + '">' + d[0] + '</option>';
        }).join('');
        $("#user_profile_state").html(html);
      },
      error: function(e) { console.log(e); }
    });
  });

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
