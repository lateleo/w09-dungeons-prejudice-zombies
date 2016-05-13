require File.expand_path('../../helpers/application_helper', __FILE__)

class Race < ActiveRecord::Base
  include ApplicationHelper

  validates_with UniversalValidator
  validates :singular, presence: true
  validates :age_of_maturity, presence: true
  validate :validate_indices
  before_validation :set_adjective

  has_many :racial_bonuses
  has_many :characters

  def validate_indices
    check_index_sum
    stats.each do |stat|
      if self.send("#{stat}_index") == nil
        errors.add(:"#{stat}_index", "cannot be blank.")
      elsif self.send("#{stat}_index") >= 3 || self.send("#{stat}_index") <= -3
        errors.add(:"#{stat}_index", "must be between -3 and 3 inclusive.")
      end
    end
  end

  def check_index_sum
    sum = 0
    stats.each do |stat|
      sum += self.send("#{stat}_index").to_i
    end
    errors.add(:stat_indices, "must add up to 0.") if sum != 0
  end

  def set_adjective
    self.adjective = self.singular if self.adjective == nil
  end

  def increase_levels_for(stat)
    incr_per_15 = 6 + self.send("#{stat}_index")
    levels = []
    1.step(by: 1, to: incr_per_15) {|i| levels.push((i * (15.0/incr_per_15)).ceil)}
    levels
  end

  private

  def race_params
    params.require(:race).permit(:name, :singular, :adjective, :age_of_maturity,
      :fortitude_index, :strength_index, :mana_index, :swiftness_index, :intuition_index,
      :description)
  end
end
