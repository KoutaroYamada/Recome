// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require uikit.min
//= require uikit-icons.min
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require tag-it
//= require_tree .

// urlが入力されると非同期でurl先のタイトルとサムネイル画像を表示
$(document).on('turbolinks:load',function(){
  const inputForm = $('#input-url-area');

  inputForm.on('keyup',function(){
    const url = $(this).val();

    $.ajax({
      type:'GET',
      url:'/articles/get_url',
      data: {keyword: url},
      datatype: 'json',
      beforeSend: function(){
        $('#url_title_and_image').removeClass('uk-animation-fade uk-animation-fast');
        // $('#url_title_and_image').addClass('loading');
      }

    })
    .done(function(){
      $('#url_title_and_image').addClass("uk-animation-fade uk-animation-fast");
      // $('#url_title_and_image').removeClass('loading');
    })
    .fail(function(data){
      console.log('非同期通信に失敗しました。');
    })

  });

  $('#article-tags').tagit();

});