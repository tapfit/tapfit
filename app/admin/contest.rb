ActiveAdmin.register Contest do
  index do
    column :name
    default_actions
  end

  filter :name
  controller do
    def to_param
      slug
    end

    def generate_slug
      self.slug ||= name.parameterize
    end

    def permitted_params
      params.permit!
    end
  end
end
