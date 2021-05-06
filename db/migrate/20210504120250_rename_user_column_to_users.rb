class RenameUserColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :user, :name
  end
end
