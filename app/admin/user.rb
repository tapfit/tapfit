ActiveAdmin.register User do

  index do
    column :first_name
    column :last_name
    column :email
    column :location
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column "Passes Purchased", sortable: 'COUNT(receipts)' do |member|
      member.receipts.count
    end
    column :total_packages
    default_actions
  end

  filter :email
  filter :location
  filter :current_sign_in_at

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

    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end

    def max_csv_records                                                          
      150_000                                                                    
    end

    def scoped_collection
      end_of_association_chain.includes(:receipts)
    end

    def permitted_params
      params.permit!
    end
  end
end
