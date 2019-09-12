class ApplicationController < ActionController::Base
  # どのコントローラでも記事の読み込みができるように、ここでopen-uriを記述
  require 'open-uri'
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :article_search
  
  # 投稿記事検索
  def  article_search
    @article_search = Article.ransack(params[:q])
    # 検索結果をインスタンスに格納　includesはN＋1問題回避のため、紐づく子モデルをまとめて読み込み
    @articles = @article_search.result(distinct: true).includes(:tags, :favorites).page(params[:page]).per(10)
    # 検索キーワードを入力した上での検索の場合、ハイライト用にキーワードをインスタンス変数に格納
    if params[:q] != nil
      @search_keyword = params[:q]["title_or_description_or_tags_name_cont"]
    end  
  end


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])
  end

end
