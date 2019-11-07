ActiveAdmin.register Member do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :email, :summary, :avatar
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :summary]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :avatar do |av|
      image_tag url_for(av.avatar)
    end
    actions
  end

  filter :name
  filter :email

  form title: "Create New Member" do |f|
    inputs 'Details' do
      input :name
      input :email
      input :summary
      input :avatar, as: :file
    end
    actions
  end

end
