class AddColumnToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :thumbnail_image_url, :text, null: false, default: ""
    add_column :articles, :description, :text, null: false, default: ""
    add_column :articles, :title, :string, null: false, default: ""
    add_index :articles, :description
    add_index :articles, :title
  end
end
