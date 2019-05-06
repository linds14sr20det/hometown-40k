class RoundsController < ApplicationController
  before_action :authenticate_user!

  def show
    @system = System.find(params[:id])
    @pairings
  end

  def initial_pairings
    # TODO: Send over a JS object that will be manipulable by the front end
    @system = System.find(params[:id])
    @pairings = get_initial_pairings(@system.registrants)
  end

  def set_initial_pairings
    system = System.find(params[:id])
    RoundIndividual.where(round: 0, system_id: system.id, player_id: system.registrants.map(&:user_id)).destroy_all
    # TODO: use the js provided object to create this
    get_initial_pairings(system.registrants).each do |pairing|
      RoundIndividual.create(player: pairing[0].user, opponent: pairing[1].user, system: system, round: 0)
      RoundIndividual.create(player: pairing[1].user, opponent: pairing[0].user, system: system, round: 0)
    end
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  def toggle_start_event
    system = System.find(params[:id])
    system.update_attributes(event_started: !system.event_started?)
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  def get_initial_pairings(registrants)
    pairings = registrants.in_groups_of(2)
    pairings.last[1] = Registrant.new(:user_id => 1) if registrants.length.odd?
    pairings
  end
end
