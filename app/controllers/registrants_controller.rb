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
    @registrant.check_in_edit
    if @registrant.update_attributes(registrant_params)
      flash[:success] = "Player updated"
      redirect_to registrants_path(cohort_id: @registrant.system.cohort.id)
    else
      flash[:warning] = "Something went wrong"
      redirect_to edit_registrant_path(@registrant)
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
    system.registrants.where(checked_in: true).each do |registrant|
      system.round_aggregates.create(
        player: registrant.user,
        wins: 0,
        losses: 0,
        draws: 0,
        total_points: 0,
        opponents: [],
        withdrawn: false,
      )
    end
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  def check_in_player
    registrant = Registrant.find(params['id'])
    registrant.check_in_edit
    registrant.checked_in = !registrant.checked_in
    registrant.save
    head :no_content
  end

  private

  def registrant_params
    params.require(:registrant).permit(:user_id, :system_id, :paid, :checked_in)
  end
end
