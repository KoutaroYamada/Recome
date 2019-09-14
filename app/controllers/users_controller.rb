class UsersController < ApplicationController
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
    @user = User.includes(articles: [:favorites, :tags]).find(params[:id])
    
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

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :profile, :profile_image)
  end  

end
