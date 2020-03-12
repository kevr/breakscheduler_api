class RemoveUserFromTickets < ActiveRecord::Migration[6.0]
  def change
    change_table :tickets do |t|
      t.remove_references :user, polymorphic: true
    end
  end
end
