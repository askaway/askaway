ActiveAdmin.register Party do
  permit_params :name, :auth_statement, :description
end
