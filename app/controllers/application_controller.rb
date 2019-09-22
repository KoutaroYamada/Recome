class ApplicationController < ActionController::Base
  # どのコントローラでも記事の読み込みができるように、ここでopen-uriを記述
  require 'open-uri'
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :article_search, :set_params
  
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

  # gonを使っていないページで"gonが未定義"のエラーを避けるため
  def set_params
    gon.available_tags = false
  end

  def after_sign_in_path_for(resource)
    # deviseのフラッシュメッセージのkeyをuikitのフラッシュメッセージのkeyに上書き
    flash.delete(:notice)
    flash[:success] = "ログインしました。"
    root_path

  end

  def after_sign_out_path_for(resource)
    # deviseのフラッシュメッセージのkeyをuikitのフラッシュメッセージのkeyに上書き
    flash.delete(:notice)
    flash[:success] = "ログアウトしました。"
    root_path

  end

  # 例外処理の記述
  if !Rails.env.development?
    rescue_from Exception,                        with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.xhr?
      render json: { error: '404 error' }, status: 404
    else
      format = params[:format] == :json ? :json : :html
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end
  end

  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e 

    if request.xhr?
      render json: { error: '500 error' }, status: 500
    else
      format = params[:format] == :json ? :json : :html
      render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])
  end

end
