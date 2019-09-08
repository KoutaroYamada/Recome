class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :get_url ]

  def index
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    
    if @article.save
      flash[:success] = "登録に成功しました。"
      redirect_to articles_path
    else
      flash[:danger] = "登録に失敗しました。"
      render :new

    end

  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  def get_url
    require 'open-uri'

    url = url_params[:keyword]
    
    #URLの取得
    @html = open(url){|f| f.read }

    @title = Nokogiri::HTML.parse(@html).title
    @image = Nokogiri::HTML.parse(@html).css('//meta[property="og:image"]/@content').to_s

  end

  private
  def article_params
    params.require(:article).permit(:url, :recommend_comment, :tag_list)
  end

  def url_params
    params.permit(:keyword)
  end

end
