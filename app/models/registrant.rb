class Registrant < ApplicationRecord
  belongs_to :system
  belongs_to :user

  scope :paid, -> { joins(:user).where(paid: true).order('name ASC') }
  scope :failed_payment, -> { joins(:user).where(paid: false).order('name ASC') }

  # validates :system_id, uniqueness: { scope: :user_id }, if: Proc.new { |registrant| registrant.paid? }
  validate :only_one_paid_registrant, unless: :post_paid_edit?

  def post_paid_edit?
    @post_paid_edit
  end

  def post_paid_edit
    @post_paid_edit = true
  end

  def only_one_paid_registrant
    if Registrant.find_by(user_id: user_id, system_id: system_id, paid: true).present?
      errors.add(:system_id, "You've already registered for this system")
    end
  end
end
