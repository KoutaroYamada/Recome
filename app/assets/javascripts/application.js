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
    $('#url_title_and_image').empty();

    if(url != ""){
      $.ajax({
        type:'GET',
        url:'/articles/get_url',
        data: {keyword: url},
        datatype: 'json',
        beforeSend: function(){
          $('#url_title_and_image').removeClass('uk-animation-fade uk-animation-fast');
          $('#url_title_and_image').addClass('loading');
        }

      })
      .done(function(){
        $('#url_title_and_image').addClass("uk-animation-fade uk-animation-fast");
        $('#url_title_and_image').removeClass('loading');

        // 記事のサムネ画像URL・タイトル・サイト名・概要を取得
        let preview_image_url = $('.article_thumbnail_image').attr('src');
        let preview_title = $('#article_title').val();
        let preview_site_name = $('#article_site_name').val();
        let preview_description = $('#article_description').val();

        // 上で取得した値をfidden_fieldに受け渡し
        $('#hidden_article_thumbnail_image_url').val(preview_image_url);
        $('#hidden_article_title').val(preview_title);
        $('#hidden_article_site_name').val(preview_site_name);
        $('#hidden_article_description').val(preview_description);
      })
      .fail(function(data){
        $('#url_title_and_image').empty();
        $('#url_title_and_image').removeClass('loading');
        // URL先が存在しない場合のエラーメッセージを表示
        $('#url_title_and_image').append('<div class="uk-alert-danger" uk-alert><p>このURLは存在しません。</p></div>');
      })
    } else{
      $('#url_title_and_image').empty();
      $('#url_title_and_image').removeClass('loading');
    }
  });

  // タグ機能有効化
  $('#article-tags').tagit();

  // クリックしたタグ名でタグを自動登録
  $('.used_tag').on('click',function(){
    let clicked_tag = $(this).text();
    $('#article-tags').tagit("createTag", clicked_tag);
  });

});
