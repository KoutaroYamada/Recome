class HomeController < ApplicationController
  before_action :set_variables

  def top
    if tag_params[:tag_name]
      # タグに紐付いた記事をお気に入り順に並び替え、10記事ごとに表示
      @articles  =  Kaminari.paginate_array(Article.includes(:tags, :favorites).create_rank(tag_params[:tag_name])).page(params[:page]).per(10)
    else
      # 全記事をお気に入り順に並び替え、10記事ごとに表示
      @articles = Kaminari.paginate_array(Article.includes(:tags, :favorites).create_rank()).page(params[:page]).per(10)
    end

    # 投稿した記事の合計お気に入られ数に基づいてユーザランキングを作成し、上から10件取得
    @users = User.create_user_rank.take(10)

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
