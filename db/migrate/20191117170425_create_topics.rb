class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.text :subject, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_index :topics, :subject
    add_index :topics, :body
  end
end
