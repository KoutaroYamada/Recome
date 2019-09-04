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

end
