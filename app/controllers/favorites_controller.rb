class FavoritesController < ApplicationController
  before_action :set_variables

  def create
    # お気に入り登録 favoriteはarticleのインスタンスメソッド
    @article.favorite(current_user)
    
  end

  def destroy
    # お気に入り解除　unfavoriteはarticleのインスタンスメソッド
    @article.unfavorite(current_user)

  end

  # お気に入りボタンを押した記事を取得
  def set_variables
    @article = Article.find(params[:article_id])
  end

end
