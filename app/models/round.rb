class Round < ApplicationRecord
  belongs_to :system
  has_many :round_individuals
end
