class Registrant < ApplicationRecord
  belongs_to :system
  belongs_to :user

  scope :paid, -> { where(paid: true) }
  scope :failed_payment, -> { where(paid: false) }
end
