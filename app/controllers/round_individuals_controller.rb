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
      RoundAggregate.create(player: pairing[0].user, system: system, wins: 0, losses: 0, draws: 0, total_points: 0, withdrawn: false, opponents: [])
      RoundAggregate.create(player: pairing[1].user, system: system, wins: 0, losses: 0, draws: 0, total_points: 0, withdrawn: false, opponents: [])
    end
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  def toggle_start_event
    system = System.find(params[:id])
    system.update_attributes(event_started: !system.event_started?)
    redirect_to registrants_path(cohort_id: system.cohort.id)
  end

  def finalize_round
    # Set outcomes of the last round
    round = params[:id].to_i
    pairings = RoundIndividual.where(round: round, system_id: params[:system_id])
    round_aggregates = RoundAggregate.where(system_id: params[:system_id])
    pairings.each do |pairing|
      para = round_aggregates.find_by(player_id: pairing.player_a.id)
      parb = round_aggregates.find_by(player_id: pairing.player_b.id)
      player_a = {win: 0, draw: 0, loss: 0}
      player_b = {win: 0, draw: 0, loss: 0}
      differential = pairing.player_a_points - pairing.player_b_points
      if differential > 0
        player_a[:win] = 1
        player_b[:loss] = 1
      elsif differential < 0
        player_a[:loss] = 1
        player_b[:win] = 1
      elsif differential == 0
        player_a[:draw] = 1
        player_b[:draw] = 1
      end
      para.update_attributes(
        total_points: para.total_points + pairing.player_a_points + (player_a[:win] * 1000) + (player_a[:draw] * 500),
        wins: para.wins + player_a[:win],
        draws: para.draws + player_a[:draw],
        losses: para.losses + player_a[:loss],
        opponents: para.opponents << pairing.player_b.id,
      )
      parb.update_attributes(
        total_points: parb.total_points + pairing.player_b_points + (player_b[:win] * 1000) + (player_b[:draw] * 500),
        wins: parb.wins + player_b[:win],
        draws: parb.draws + player_b[:draw],
        losses: parb.losses + player_b[:loss],
        opponents: parb.opponents << pairing.player_a.id,
      )
    end

    # TODO: Increment the round number so you can't mess up previous rounds

    # Setup the next round
    round_aggregates = RoundAggregate.where(system: params[:system_id]).order(total_points: :desc)
    # TODO: Sort pairings to avoid prior played opponents
    new_pairings = round_aggregates.in_groups_of(2, RoundAggregate.new(player_id: 1, system_id: params[:system_id]))
    new_pairings.each do |pairing|
      RoundIndividual.create(player_a: pairing[0].player, player_b: pairing[1].player, system: pairing[0].system, round: round + 1)
    end
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
