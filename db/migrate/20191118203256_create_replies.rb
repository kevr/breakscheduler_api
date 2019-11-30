class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.belongs_to :ticket
      t.belongs_to :user, polymorphic: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
