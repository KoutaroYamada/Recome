class Article < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  #タグ機能実装
  acts_as_taggable

  #空欄不許可
  validates :url, presence: true
  #空欄不許可、文字数は最大400文字まで
  validates :recommend_comment, presence: true, length: { maximum: 400 }

  # 登録タグの最大数制限
  validates_size_of     :tag_list,
                        maximum: 5,
                        message: '登録タグ数は最大10です。'

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
      #タグを含むArticleモデルを抽出して、お気に入りの数でソートをかける
      all.select{ |article| article.tag_list.include?(tag) }.sort_by{|article| article.favorites.count}.reverse

    else
    #  　記事全全件をお気に入りの数でソートをかける
      all.sort_by{|article| article.favorites.count}.reverse

    end

  end 

end
