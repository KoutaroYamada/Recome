class UsersController < ApplicationController
  before_action :set_mypage_user, only: [:show, :favorites, :following, :followers, :add_favorite_tag, :remove_favorite_tag]

  def index
  end

  def new
  end

  def create
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
      # flash[:success] = "プロフィールの編集が完了しました。"
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
    @user.tag_list.add(tag_params[:tag])
    @user.save
    redirect_to user_path
  end

  def remove_favorite_tag
    @user.tag_list.remove(tag_params[:tag])
    @user.save
    redirect_to user_path
  end

  def set_mypage_user
    #マイページで開いたユーザのデータを取得
    @user = User.includes(:tags, articles: [:favorites, :tags]).find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :profile, :profile_image, :tag_list)
  end

  def tag_params
    params.require(:user).permit(:tag)
  end

end
