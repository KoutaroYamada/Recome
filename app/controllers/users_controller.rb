class UsersController < ApplicationController
  before_action :set_mypage_user, only: [:show, :favorites, :following, :followers, :add_favorite_tag, :remove_favorite_tag, :tag_search]

  def index
    @user_search = User.ransack(params[:q])
    # 検索結果をインスタンスに格納　includesはN＋1問題回避のため、紐づく子モデルをまとめて読み込み
    @users = @user_search.result(distinct: true).includes(:tags).page(params[:page]).per(20)

  end

  def my_collection

  end

  def edit
    @user = User.find(current_user.id)
  end

  def show
    @articles = @user.articles
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールの編集が完了しました。"
      redirect_to user_path
    else
      render :edit
    end

  end

  def destroy
  end

  def following
    @following = @user.following

  end

  def followers
    @followers = @user.followers
  end

  def favorites
    @articles = @user.favorite_articles
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
  end

  def set_mypage_user
    #マイページで開いたユーザのデータを取得
    @user = User.includes(:tags, articles: [:favorites, :tags]).find(params[:id])
    # 遷移元のページの情報を渡す（お気に入りタグの登録/解除をしたとき、トップページとマイページどちらの
    # お気に入りタグ一覧を変更するかの条件分岐に使う）
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

end
