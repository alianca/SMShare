$(document).ready(function() {
  tinyMCE.init({
    mode: 'textareas',
    theme: 'advanced',
    theme_advanced_toolbar_location: 'top',
    theme_advanced_toolbar_align: 'left',
    theme_advanced_buttons1: [
      'fontselect',
      'fontsizeselect',
      'forecolor',
      'separator',
      'bold',
      'italic',
      'underline',
      'strikethrough',
      'separator',
      'justifyleft',
      'justifycenter',
      'justifyright',
      'justifyfull',
      'separator',
      'code'
    ].join(','),
    theme_advanced_buttons2: '',
    theme_advanced_buttons3: '',
    plugins: 'contextmenu,paste'
  });
});
