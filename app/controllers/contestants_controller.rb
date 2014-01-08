class ContestantsController < ApplicationController
  before_action :set_contestant, only: [:show, :edit, :update, :destroy]

  # GET /contestants/new
  def new
    session[:contestant_params] ||= {}
    @contestant = Contestant.new(session[:contestant_params])
    @contestant.current_step = session[:contestant_step]
  end

  def show
  end

  # POST /contestants
  def create
    session[:contestant_params].deep_merge!(params[:contestant]) if params[:contestant]
    @contestant = Contestant.new(session[:contestant_params])
    @contestant.current_step = session[:contestant_step]

    if @contestant.valid?
      if params[:back_button]
        @contestant.previous_step
      elsif @contestant.last_step?
        @contestant.save if @contestant.all_valid?
      else
        @contestant.next_step
      end
      session[:contestant_step] = @contestant.current_step
    end
    if @contestant.new_record?
      render "new"
    else
      session[:contestant_step] = session[:contestant_params] = nil
      flash[:notice] = "Contestant Saved!"
      redirect_to @contestant
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contestant
      @contestant = Contestant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contestant_params
      params.require(:contestant).permit(:email, :has_downloaded, :has_shared, :index, :show, :new)
    end
end
