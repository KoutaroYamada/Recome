class Article < ApplicationRecord
  belongs_to :user
  #タグ機能実装
  acts_as_taggable
end
