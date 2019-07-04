class RegistrantsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cohort = Cohort.find(params[:cohort_id])
  end

  def new
    @system = System.find(params[:system_id])
    @registrant = @system.registrants.new
  end

  def create
    @registrant = Registrant.new(registrant_params)
    if @registrant.save
      flash[:success] = "Player created."
      redirect_to registrants_path(cohort_id: @registrant.system.cohort.id)
    else
      render 'new'
    end
  end

  def edit
    @registrant = Registrant.find(params[:id])
  end

  def update
    @registrant = Registrant.find(params[:id])
    if @registrant.update_attributes(registrant_params)
      flash[:success] = "Player updated"
      redirect_to registrants_path(cohort_id: @registrant.system.cohort.id)
    else
      redirect_to edit_registrants_path(@registrant)
    end
  end

  def destroy
    registrant = Registrant.find(params[:id])
    if registrant.destroy
      flash[:success] = "Player deleted"
    end
    redirect_to registrants_path(cohort_id: registrant.system.cohort.id)
  end

  def toggle_start_event
    system = System.find(params[:id])
    system.update_attributes(event_started: !system.event_started?)
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  private

    def registrant_params
      params.require(:registrant).permit(:user_id, :system_id, :paid)
    end

    # Before filters

end
