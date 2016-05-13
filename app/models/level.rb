class Level < ActiveRecord::Base
  validates :character_id, presence: true
  validates :class_id, presence: true
  validates :character_level, presence: true, numericality: {greater_than_or_equal_to: 0},
    uniqueness: {scope: :character_id}
  validates :ability_id, presence: true, uniqueness: {scope: :character_id}
  validate :validate_increases

  belongs_to :character
  belongs_to :char_class, class_name: "CharacterClass", foreign_key: "class_id"
  belongs_to :ability

  def validate_increases
    sum = 0
    stats.each do |stat|
      sum += self.send("#{stat}_index").to_i
      if self.send("#{stat}_index") == nil
        errors.add(:"#{stat}_index", "cannot be blank.")
      elsif self.send("#{stat}_index") < 0
        errors.add(:"#{stat}_index", "must be greater than or equal to 0.")
      end
    end
    if self.character_level > 1
      errors.add(:stat_increases, "must add up to 5.") if sum != 5 + racial_increase_sum
    elsif self.character_level == 1
      errors.add(:stat_increases, "can only come from racial stat indices at level 1.") if sum != racial_increase_sum
    end
  end

  def racial_increase_for(stat)
    increase_values = self.character.race.send(:increase_levels_for, stat)
    adjusted_level = ((self.character_level + self.character.send("#{stat}_offset") - 1) % 15) + 1
    increase_values.include?(adjusted_level) ? 1 : 0
  end

  def racial_increase_sum
    sum = 0
    stats.each do |stat|
      sum += racial_increase_for(stat)
    end
  end

  private

  def level_params
    params.require(:level).permit(:character_id, :class_id, :character_level,
      :ability_id, :fortitude_increase, :strength_increase, :mana_increase,
      :swiftness_increase, :intuition_increase)
  end
end
