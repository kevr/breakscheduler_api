class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.text :title, null: false
      t.text :body, null: false

      t.integer :order

      t.timestamps
    end

    add_index :articles, :order, unique: true
  end
end
