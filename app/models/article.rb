class Article < ApplicationRecord
  belongs_to :user
  #タグ機能実装
  acts_as_taggable

  #空欄不許可
  validates :url, presence: true
  #空欄不許可、文字数は最大400文字まで
  validates :recommend_comment, presence: true, length: { maximum: 400 }
end
