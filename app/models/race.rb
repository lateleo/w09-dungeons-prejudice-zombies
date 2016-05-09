class Race < ActiveRecord::Base
  validates :plural, presence: true
  validates :singular, presence: true
  validates :adjective, presence: true
  validates :age_of_maturity, presence: true
  validate :validate_indices
  before_validation :set_adjective

  def validate_indices
    sum = fortitude_index + strength_index + mana_index + swiftness_index + intuition_index
    errors.add(:stat_indices, "must add up to 0.") if sum != 0
  end

  def set_adjective
    self.adjective = self.singular if self.adjective == nil
  end

end
