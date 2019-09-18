class HomeController < ApplicationController
  def top
    @popular_tags = ActsAsTaggableOn::Tag.most_used(5)
    @favorite_tags = current_user.tags
    # 遷移元のページの情報を渡す（お気に入りタグの登録/解除をしたとき、トップページとマイページどちらの
    # お気に入りタグ一覧を変更するかの条件分岐に使う）
    @path = Rails.application.routes.recognize_path(request.referer)
  end

end
