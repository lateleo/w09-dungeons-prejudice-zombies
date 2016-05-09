class Level < ActiveRecord::Base
  validates :character_id, presence: true
  validates :char_class_id, presence: true
  validates :character_level, presence: true
  validates :class_level, presence: true
  validates :ability_id, presence: true
  validate :validate_increases

  belongs_to :character
  belongs_to :char_class, model: :character_class
  belongs_to :ability

  def validate_increases
    if self.character_level != 0
      sum = fortitude_increase + strength_increase + mana_increase + swiftness_increase + intuition_increase
      errors.add(:stat_increases, "must add up to 5.") if sum != 5
    end
  end

end
