class ApplicationController < ActionController::Base
  # どのコントローラでも記事の読み込みができるように、ここでopen-uriを記述
  require 'open-uri'
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :article_search
  
  # 投稿記事検索
  def  article_search
    @article_search = Article.ransack(params[:q])
    @articles = @article_search.result(distinct: true).page(params[:page]).per(10)
    @search_keyword = params[:q]["title_or_description_or_tags_name_cont"]
  end


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])
  end

end
