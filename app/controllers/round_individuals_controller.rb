class RoundIndividualsController < ApplicationController
  before_action :authenticate_user!

  def show
    @round = params[:id]
    @system = System.find(params[:system_id])
    @pairings = RoundIndividual.where(round: @round, system: @system).order(:id)
  end

  def edit
    @pairing = RoundIndividual.find(params[:id])
  end

  def update
    # TODO: Make sure this is only submittable if round is current
    pairing = RoundIndividual.find(params[:id])
    pairing.update_attributes(round_individual_params)
    redirect_to round_individual_path(id: pairing.round, system_id: pairing.system_id)
  end

  def initial_pairings
    # TODO: Send over a JS object that will be manipulable by the front end
    @system = System.find(params[:id])
    @pairings = get_initial_pairings(@system.registrants)
  end

  def set_initial_pairings
    system = System.find(params[:id])
    RoundIndividual.where(round: 0, system_id: system.id, player_a: system.registrants.map(&:user_id)).destroy_all
    # TODO: use the js provided object to create this
    get_initial_pairings(system.registrants).each do |pairing|
      RoundIndividual.create(player_a: pairing[0].user, player_b: pairing[1].user, system: system, round: 0)
    end
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  def toggle_start_event
    system = System.find(params[:id])
    system.update_attributes(event_started: !system.event_started?)
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  def finalize_round
    round = params[:id].to_i
    redirect_to round_individual_path(id: round + 1, system_id: params[:system_id])
  end
  private

  def round_individual_params
    params.require(:round_individual).permit(:player_a_points, :player_b_points)
  end

  def get_initial_pairings(registrants)
    registrants.in_groups_of(2, Registrant.new(:user_id => 1))
  end
end
