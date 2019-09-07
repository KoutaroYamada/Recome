class ArticlesController < ApplicationController
  def index
  end

  def new
    @article = Article.new
  end

  def create
    require 'open-uri'

    @article = Article.new(article_params)
    
    #URLの取得
    @html = open(@article.url){|f| f.read }

    @title = Nokogiri::HTML.parse(@html).title
    @image = Nokogiri::HTML.parse(@html).css('//meta[property="og:image"]/@content').to_s
    

    # @contents = Nokogiri::HTML(html,nil,'utf-8')
    render 'index'

  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  private
  def article_params
    params.require(:article).permit(:url)
  end

end
