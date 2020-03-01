class AddKeyToTicket < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :key, :string

    Ticket.all.each do |ticket|
      ticket.key = SecureRandom.uuid
      ticket.save!
    end

    change_column_null :tickets, :key, false
  end
end
