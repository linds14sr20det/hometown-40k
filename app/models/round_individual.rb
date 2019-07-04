class RoundIndividual < ApplicationRecord
  belongs_to :round
  belongs_to :player_a, :class_name => "User"
  belongs_to :player_b, :class_name => "User"
end
