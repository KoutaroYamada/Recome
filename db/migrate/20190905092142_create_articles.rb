class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.references :user, foreign_key: true
      t.string :url
      t.string :Abbreviated_url
      t.text :recommend_comment

      t.timestamps
    end
  end
end
