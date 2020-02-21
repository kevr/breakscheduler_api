ActiveAdmin.register Article do
  permit_params :subject, :body, :order
end
