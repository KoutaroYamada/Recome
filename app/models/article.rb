class Article < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  #タグ機能実装
  acts_as_taggable

  #空欄不許可
  validates :url, presence: true
  #空欄不許可、文字数は最大400文字まで
  validates :recommend_comment, presence: true, length: { maximum: 400 }

  # 記事をお気に入り登録する
  def favorite(user)
    favorites.create(user_id: user.id)
  end

  # 記事のお気に入りを解除する
  def unfavorite(user)
    favorites.find_by(user_id: user.id).destroy
  end

  # ランキング作成のクラスメソッド
  def self.create_rank(tag=nil)
    if tag
      all_sorted_article = Article.find(Favorite.group(:article_id).order('count(article_id) desc').pluck(:article_id))
      all_sorted_article.select{ |article| article.tag_list.include?(tag) }

    else
      find(Favorite.group(:article_id).order('count(article_id) desc').pluck(:article_id))
    end

  end 

end
