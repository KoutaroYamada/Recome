class AddColumnToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :thumbnail_image_url, :text
    add_column :articles, :description, :text
    add_column :articles, :title, :string, null: false, default: ""
    add_column :articles, :site_name, :string, null: false, default: ""
    add_index :articles, :description, length:255
    add_index :articles, :title, length:255
  end
end
