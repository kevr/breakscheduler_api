class AddTitleToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :title, :string
  end
end
