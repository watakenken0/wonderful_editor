class RemoveIntegerFromArticles < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :Integer, :string
  end
end
