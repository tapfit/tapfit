ActiveAdmin.register User do
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :type
      f.input :first_name
      f.input :last_name
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
