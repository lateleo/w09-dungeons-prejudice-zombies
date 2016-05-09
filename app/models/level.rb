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
      errors.add(:stat_increases, "must add up to 5.") if sum != 5 + racial_increase_sum
    end
  end

  def racial_increase_for(stat)
    increase_values = self.character.race.send("#{stat}_index")
    adjusted_level = ((self.character_level + self.character.send("#{stat}_offset") - 1) % 15) + 1
    increase_values.include?(adjusted_level) ? 1 : 0
  end

  def racial_increase_sum
    sum = 0
    all_stats.each do |stat|
      sum += racial_increase_for(stat)
    end
  end

end
