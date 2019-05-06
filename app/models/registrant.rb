class Registrant < ApplicationRecord
  belongs_to :system
  belongs_to :user

  scope :paid, -> { where(paid: true) }
  scope :failed_payment, -> { where(paid: false) }

  # validates :system_id, uniqueness: { scope: :user_id }, if: Proc.new { |registrant| registrant.paid? }
  validate :only_one_paid_registrant

  def only_one_paid_registrant
    if Registrant.find_by(user_id: user_id, system_id: system_id, paid: true).present?
      errors.add(:system_id, "You've already registered for this system")
    end
  end
end
