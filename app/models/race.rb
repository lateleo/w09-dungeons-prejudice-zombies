class Race < ActiveRecord::Base
  validates :plural, presence: true
  validates :singular, presence: true
  validates :adjective, presence: true
  validates :age_of_maturity, presence: true
  validate :validate_indices
  before_validation :set_adjective

  has_many :racial_bonuses
  has_many :characters

  def validate_indices
    sum = fortitude_index + strength_index + mana_index + swiftness_index + intuition_index
    errors.add(:stat_indices, "must add up to 0.") if sum != 0
  end

  def set_adjective
    self.adjective = self.singular if self.adjective == nil
  end

  def increase_levels(stat_index)
    incr_per_15 = 6 + stat_index
    levels = []
    1.step(by: 1, to: incr_per_15) {|i| levels.push( ((i * 15.0)/6).ceil)}
    levels
  end
end
