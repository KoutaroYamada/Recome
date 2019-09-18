class HomeController < ApplicationController
  before_action :set_variables

  def top
    if tag_params[:tag_name]
      @articles  =  Article.tagged_with(tag_params[:tag_name])
    else
      @articles = Article.all.create_rank
    end

  end

  def set_variables
    @popular_tags = ActsAsTaggableOn::Tag.most_used(5)
    # 遷移元のページの情報を渡す（お気に入りタグの登録/解除をしたとき、トップページとマイページどちらの
    # お気に入りタグ一覧を変更するかの条件分岐に使う）
    @path = Rails.application.routes.recognize_path(request.referer)

    if user_signed_in?
      @favorite_tags = current_user.tags
    end

  end

  def tag_params
    params.permit(:tag_name)
  end

end
