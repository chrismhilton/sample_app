// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function($) {

    // micropost content character counter
    var options = {
            'maxCharacterSize': 140,
            'originalStyle': 'originalDisplayInfo',
            'warningStyle': 'warningDisplayInfo',
            'warningNumber': 10,
            'displayFormat': '#input Characters | #left Characters Left | #words Words'
    };

    $('#micropost_content').textareaCount(options);
});
