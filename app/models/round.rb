class Round < ApplicationRecord
  belongs_to :system
  has_many :round_individuals
  accepts_nested_attributes_for :round_individuals
end
