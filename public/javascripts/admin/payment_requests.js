$(document).ready(function() {

    $('#all-requests').click(function() {
        $('input[type=checkbox]').prop('checked', true);
    });

    $('input[type=checkbox]').change(function() {
        return true;
    });

});
