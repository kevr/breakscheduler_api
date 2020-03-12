ActiveAdmin.register User do
  permit_params :user_type, :name, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :user_type
    column :name
    column :email
    actions
  end

  filter :name
  filter :email
  filter :user_type

  form title: "Create New User" do |f|
    inputs 'Details' do
      input :user_type
      input :name
      input :email
      input :password
      input :password_confirmation
    end
    actions
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
