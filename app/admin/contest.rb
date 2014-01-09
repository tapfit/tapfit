ActiveAdmin.register Contest do
  index do
    column :name
    default_actions
  end

  filter :name
  controller do
    def permitted_params
      params.permit!
    end
  end
end
