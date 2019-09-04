class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_name, :string, null: false, default: ""
    add_column :users, :profile, :text
    add_column :users, :profile_image_id, :string
    add_index :users, :name, unique: true
  end
end
