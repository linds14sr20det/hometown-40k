module RoundHelper
  def already_played?(system_id, player_id, opponent_id)
    ra = RoundAggregate.where(system_id: system_id).where(player_id: player_id).first
    ra.opponents.include?(opponent_id)
  end
end
