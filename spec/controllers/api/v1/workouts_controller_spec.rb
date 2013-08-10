require 'spec_helper'

describe Api::V1::WorkoutsController do

  before(:each) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address = @address
    @place.save
    @workout = FactoryGirl.create(:workout)
    @place.workouts << @workout
    puts @place.id
    @place.save
  end

  describe 'GET #index' do
    it 'should give me all worktous for a place' do
      get :index, place_id: @place.id
      assigns(:workouts).to_a.should eql([@workout])
    end

    it 'should not show workout for invalid place' do
      get :index, place_id: -1
      response.body.should include("errors") 
    end
  end

  describe 'GET #show' do
    it 'should show me on workout' do
      get :show, place_id: @place.id, id: @workout.id
      assigns(:workout).should eql(@workout)
    end
  end

  describe 'POST #buy' do
    it 'should buy a pass for a user' do
      
    end
  end

end
