ActiveAdmin.register Ticket do
  permit_params :email, :subject, :body, :status

  index do
    selectable_column
    id_column
    column :email
    column :subject
    column :status
    actions
  end

  filter :email
  filter :subject
  filter :status

  form title: "Create New Ticket" do |f|
    inputs 'Details' do
      input :status
      input :subject
      input :body
      input :email
    end
    actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_type, :user_id, :subject, :body, :status, :email, :key
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_type, :user_id, :subject, :body, :status, :email, :key]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
