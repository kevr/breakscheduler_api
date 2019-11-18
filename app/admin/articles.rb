ActiveAdmin.register Article do
  permit_params :title, :body, :order
end
