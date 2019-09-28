class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :add_favorite_tag, :remove_favorite_tag, :tag_search ]
  before_action :set_mypage_user, except: [:index, :tag_search]
  before_action :correct_user, only: [:edit, :update]

  def index
    @user_search = User.ransack(params[:q])
    # 検索結果をインスタンスに格納　includesはN＋1問題回避のため、紐づく子モデルをまとめて読み込み
    @users = @user_search.result(distinct: true).includes(:tags).page(params[:page]).per(20)
    if params[:q] != nil
      @search_keyword = params[:q]["user_name_or_tags_name_cont"]
    end  

  end

  def edit
    @user = User.find(current_user.id)
  end

  def show
    @contents_number = @user.articles.count
    @articles = @user.articles.page(params[:page]).per(3)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールの編集が完了しました。"
      redirect_to user_path
    else
      flash.now[:danger] = "プロフィールの更新に失敗しました。"
      render :edit
    end

  end

  def my_collection
    following_user_id = @user.following.pluck("id")
    tag_article_ids = Article.tagged_with(@user.tags.pluck("name"), any: true).pluck(:id)

    # フォロー中のユーザが投稿した記事か、お気に入りタグが紐付けされた記事を取得
    my_collection_articles = Article
                              .where(user_id: following_user_id)
                              .or(Article.where(id: tag_article_ids).where.not(user_id: @user.id))
                              .order("created_at DESC")

    @contents_number = my_collection_articles.count

    # マイコレクション記事を15記事ごとに表示
    @articles = my_collection_articles.page(params[:page]).per(3)

  end

  def following
    @contents_number = @user.following.count
    @following = @user.following.page(params[:page]).per(3)

  end

  def followers
    @contents_number = @user.followers.count
    @followers = @user.followers.page(params[:page]).per(3)

  end

  def favorites
    @contents_number = @user.favorite_articles.count
    @articles = @user.favorite_articles.page(params[:page]).per(3)
  end

  def add_favorite_tag
    @user.tag_list.add(tag_params[:name])

    if @user.save
        @user.reload
        @tag = @user.tags.find(tag_params[:id])
        respond_to do |format|
          format.js 
        end
    else
      @tag = ActsAsTaggableOn::Tag.find(tag_params[:id])
      flash.now[:danger] = "タグの登録に失敗しました。"
      respond_to do |format|
        format.js 
      end
    end  
  
  end

  def remove_favorite_tag
    @user.tag_list.remove(tag_params[:name])
    @user.save
    @user.reload
    @tag = ActsAsTaggableOn::Tag.find(tag_params[:id])

  end

  def tag_search
    # フォームに入力されたキーワードを取得
    search_words = tag_search_words_params[:keyword]
    @searched_tags = ActsAsTaggableOn::Tag.named_like(search_words)
    @user = current_user
  end

  def set_mypage_user
    #マイページで開いたユーザのデータを取得
    @user = User.includes(:tags, articles: [:favorites, :tags]).find(params[:id])
    # 遷移元のページの情報を渡す（お気に入りタグの登録/解除をしたとき、トップページとマイページどちらのお気に入りタグ一覧を変更するかの条件分岐に使う）
    @path = Rails.application.routes.recognize_path(request.referer)

  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :profile, :profile_image, :tag_list)
  end

  def tag_params
    params.require(:user).permit(:id,:name)
  end

  def tag_search_words_params
    params.permit(:keyword)
  end

  # 正しいユーザか確認
  def correct_user
    redirect_to(root_url) unless @user == current_user
  end

end
