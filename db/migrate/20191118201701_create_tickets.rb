class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.belongs_to :user, polymorphic: true
      t.string :subject, null: false
      t.text :body, null: false

      t.integer :status, default: 0

      t.timestamps
    end
  end
end
