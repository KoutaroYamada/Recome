class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :get_url ]

  def index
    @articles = Article.all

  end

  def new
    @article = Article.new
    # タグ一覧を変数に格納  gonはrailsのデータをjsに渡せるようにするためのgem tag-it.jsで使用
    gon.available_tags = Article.tags_on(:tags).pluck(:name)
    #過去自分が使ったタグ
    @used_tags = Article.where(user_id: current_user.id).tags_on(:tags).pluck(:name)

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
    # フォームに入力されたURLを非同期で取得
    url = url_params[:keyword]

    #同じURLを同じユーザが過去に投稿したことがない場合
    if !(Article.where(url: url, user_id: current_user.id).exists?)
      #URLを読み込み
      doc = Nokogiri::HTML.parse(open(url){|f| f.read })
      #タイトルを抽出
      @title = doc.title
      #サムネイル画像のリンクを抽出
      @image = doc.css('//meta[property="og:image"]/@content').to_s
      #記事の概要を抽出
      @description = doc.css('//meta[name="description"]/@content').to_s
      #name="description"にない場合
      if @description.empty?
        @description = doc.css('//meta[property="og:description"]/@content').to_s
      end

      # 投稿済でないことを示すフラグ。get_url.js.erbでrenderするhtml.erbの条件分岐に使う
      @status = :success 

    end  

  end

  def input_tag
    
  end

  private
  def article_params
    params.require(:article).permit(:url, :recommend_comment, :tag_list)
  end

  def url_params
    params.permit(:keyword)
  end

end
