class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #空欄不許可、同じ名前登録不可、文字数は3文字から30文字まで
  validates :user_name, presence: true, uniqueness: true, length: { in: 3..30 }

  #@マークを含む、「.」を含むメールアドレスのみ許可
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  #300文字以上の自己紹介文を不許可
  validates :profile, length: { maximum: 300 }

  attachment :profile_image
  has_many :articles, dependent: :destroy
  has_many :favorites, dependent: :destroy
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

end
