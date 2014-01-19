ActiveAdmin.register InvitationCode do

  index do
    column :code
    column :amount
    column :user_id, :type => :integer
    column :codes_used

    default_actions
  end

end 
