class ModifyOwnerOfTicket < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :email, :string

    Ticket.find_each do |ticket|
      ticket.email = ticket.user.email
      ticket.save!
    end

    change_column_null :tickets, :email, false

    remove_column :tickets, :user
  end
end
