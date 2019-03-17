// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap
//= require_tree .
//= require bootstrap-datepicker
//= require jquery.ui.widget
//= require z.jquery.fileupload
//= require cocoon
//= require froala_editor.min.js
//= require plugins/image.min.js
//= require plugins/link.min.js

$(document).ready(function(){
    $('textarea:not(.no-wysiwyg)').froalaEditor($.froala_creds);
});

$(document).on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('textarea').froalaEditor($.froala_creds);
});

$.fn.datepicker.defaults.format = "yyyy-mm-dd";
