class ModifyOwnerOfReply < ActiveRecord::Migration[6.0]
  def change
    add_column :replies, :email, :string

    Reply.find_each do |reply|
      reply.email = reply.user.email
      reply.save!
    end

    change_column_null :replies, :email, false

    remove_column :replies, :user
  end
end
