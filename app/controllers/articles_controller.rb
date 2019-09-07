class ArticlesController < ApplicationController
  def index
  end

  def new
    @article = Article.new
  end

  def create
 
    

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
    params.require(:article).permit(:url)
  end

  def url_params
    params.permit(:keyword)
  end

end
