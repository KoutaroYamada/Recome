class FavoritesController < ApplicationController
  before_action :set_variables

  def create
    favorite = current_user.favorites.new(article_id: @article.id)
    favorite.save    
  end

  def destroy
    favorite = current_user.favorites.find_by(article_id: @article.id)
    favorite.destroy
  end

  def set_variables
    @article = Article.find(params[:id])
    @id_name = "#favorite-link-#{@article.id}"
    @id_heart = "#favorite-#{@article.id}"
  end

end
