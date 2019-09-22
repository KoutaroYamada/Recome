class User < ApplicationRecord
  #ユーザのお気に入りタグ登録実装のため、タグ機能実装
  acts_as_taggable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #空欄不許可、同じ名前登録不可、文字数は3文字から30文字まで
  validates :user_name, presence: true, uniqueness: true, length: { in: 3..30 }

  #@マークを含む、「.」を含むメールアドレスのみ許可
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  #100文字以上の自己紹介文を不許可
  validates :profile, length: { maximum: 100 }

  # 登録タグの最大数制限
  validates_size_of     :tag_list,
                        maximum: 10,
                        message: 'お気に入り登録できるタグは10までです。'

  attachment :profile_image
  has_many :articles, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_articles, through: :favorites, source: :article

  has_many :active_relationships, class_name: "Relationship",
            foreign_key: "follower_id",
            dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
            foreign_key: "followed_id",
            dependent: :destroy            
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # ユーザがいいね済かどうかを判断するロジック
  def favorite?(article)
    favorites.pluck(:article_id).include?(article.id)
  end

  #他ユーザをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  #他ユーザをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # タグをお気に入り登録済みか判断するロジック
  def tag_favorite?(tag)
    tags.pluck(:id).include?(tag.id)
  end

  # ユーザが投稿した記事のお気に入りされた数合計でユーザランキングを作成するメソッド
  def self.create_user_rank

    # 記事IDごとのお気に入りの数を集計する空の配列を用意
    article_favorite_counts_data = []

    Article.includes(:favorites).all.each do |article| 
      # 上記の空配列に、記事に紐づくユーザIDとお気に入りの数をハッシュの形式で格納
      article_favorite_counts_data.push({ user_id: article.user_id, favorites_count: article.favorites.count})
    end

    # 記事IDごとのユーザIDとお気に入り数を格納した配列を、ユーザIDでグルーピング
    data = article_favorite_counts_data.group_by{|elem| elem[:user_id]}

    # ユーザIDと、各ユーザの投稿記事がお気に入りされた数合計を格納する配列を用意
    user_favorite_counts_data = []

    # keyはユーザID、arrはユーザが投稿した記事ごとのお気に入り数合計が格納された配列
    data.each do |key,arr|
      sum = arr.inject(0) {|memo, item| memo + item[:favorites_count]}
      user_favorite_counts_data << {user_id: key, favorites_count: sum }
    end  

    ranked_data = user_favorite_counts_data.sort_by!{|data| data[:favorites_count]}.reverse.map{|n| n= n[:user_id]}

    User.find(ranked_data)

  end

  def count_all_favorites
    sum = 0
    articles.each do |article|
      sum += article.favorites.count
    end

    sum

  end

end
