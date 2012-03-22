$(document).ready(function() {
    /* Troca o fundo do botão em mouse over */
    $("#files_submit, #links-container a.confirmar").mouseover(function () {
        $(this).css("background", "url(/images/user_files/botao-on.png)");
    });

    /* Volta o fundo padrão quando perde o mouse over */
    $("#files_submit, #links-container a.confirmar").mouseout(function () {
        $(this).css("background", "url(/images/user_files/botao-off.png)");
    });

    $("#categories-list input[type=checkbox]").change(function () {

        $("#user_file_categories_input input[value=" + this.value + "]").attr("checked", $(this).attr("checked"));
    });

    /* Altera o formato do link */
    $("#link-type-buttons-container input[name='link-type-option']").change(function () {
        field = $('#links-container #link-boxes-container .link-box .link-field');
        selected = $("input[name='link-type-option']:checked").val();
        if (selected == "type-html") {
            field.attr('value', '<a href=\"' + field.attr('url-text') + '\">Link</a>');
        } else if (selected == "type-forum") {
            field.attr('value', '[url=\"' + field.attr('url-text') + '\"]Link[/url]');
        } else if (selected == "type-sharebox") {
            field.attr('value', field.attr('url-text'));
        } else {
            field.attr('value', field.attr('url-text'));
        }
    });

    /* marca as estrelas quando seleciona a nota, e seta o campo invisível */
    $("#file-container .comments #new-comment-form .rate-file .star").click(function() {
        var index = $(this).attr('class').match(/index(\d+)/)[1];
        $("#file-container .comments #new-comment-form #comment_rate").attr('value', index);
        for (var i = 1; i <= 5; i++) {
            var element = $("#file-container .comments #new-comment-form .rate-file .star.index" + i);
            element.css('background', 'url(/images/search/icone-nota-' + (i<=index ? 'on' : 'off') + '.png) no-repeat');
        }
    });

    /* Atualiza o contador de caracteres restantes */
    $("#file-container .comments #new-comment-form #comment_message").keyup(function() {
        var counter = $("#file-container .comments #new-comment-form .characters .character-counter");
        counter.text(280 - $(this).val().length);
    });

});

/* Faz pre-cache das imagens do cadastro */
cache_images("/images/user_files/botao-on.png");
