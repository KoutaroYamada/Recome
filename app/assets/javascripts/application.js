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
//= require uikit.min
//= require uikit-icons.min
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require tag-it
//= require infinite-scroll.pkgd.min
//= require_tree .

// urlが入力されると非同期でurl先のタイトルとサムネイル画像を表示
$(function(){
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

  // 選択した画像を非同期で表示
  $('#selectProfileImage').on('change', function(element) {
    var reader = new FileReader();
    reader.readAsDataURL(element.target.files[0]);
    reader.onload = function(e) {
      $('#profileImage').attr('src', e.target.result);
    }
    
  });

// お気に入りタグ検索のインクリメンタルサーチ
  $('#favorite-tag-search').on('keyup',function(){
    const search_words = $(this).val();

      $.ajax({
        type:'GET',
        url:'/users/tag_search',
        data: {keyword: search_words},
        datatype: 'json',
      })
      .fail(function(data){
        alert('非同期通信に失敗しました。');
      })
  });

  // トップページ　無限スクロール
  $('#top-page-articles').infiniteScroll({
    path: "nav.pagination a[rel=next]",
    append: ".top-page-article",
    history: false,
    prefill: false,
    status: '.page-load-status'
  });

  // マイページの記事一覧　無限スクロール
  $("#mypage-contents").infiniteScroll({
    path: "nav.pagination a[rel=next]",
    append: ".mypage-article",
    history: false,
    prefill: false,
    status: '.page-load-status',
    checkLastPage: true
  });

  // マイページのフォロー中ユーザ/フォロワー一覧　無限スクロール
  $("#mypage-contents").infiniteScroll({
    path: "nav.pagination a[rel=next]",
    append: ".mypage-related-user",
    history: false,
    prefill: false,
    status: '.page-load-status',
    checkLastPage: true
  });


  // ↓お気に入りボタンがオンマウスになったらツールチップが一定時間後に表示される
  // 機能を実装したかったが、時間の都合上あきらめ
  　
  // $('.fa-star').hover(function() {
  //   $(this).parent().find('#favorite-button-text').addClass("visible");

  //   var t = setTimeout(function() {
  //     $(this).find('#favorite-button-text').addClass("visible");
  //   }, 500);
  //   $(this).data('timeout', t);
  // }, function() {
  //   $(this).find('#favorite-button-text').removeClass("visible");
  //   clearTimeout($(this).data('timeout'));
  // });

});
