class ChangeTitleToSubject < ActiveRecord::Migration[6.0]
  def change
    rename_column :articles, :title, :subject
  end
end
