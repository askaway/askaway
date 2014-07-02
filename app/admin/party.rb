ActiveAdmin.register Party do
  permit_params :name, :auth_statement, :description

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
