ActiveAdmin.register Contestant do
  index do
    column :email
    column :has_downloaded
    column :has_shared
    default_actions
  end
  
  controller do
    def permitted_params
      params.permit!
    end
  end
end
