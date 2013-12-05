
class EmailCollectionsController < ApplicationController

  def create
    @email_collection = EmailCollection.create(email_collection_params)
  end

  private

  def email_collection_params
    params.require(:email_collection).permit(:email, :city)
  end 
end
