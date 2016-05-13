require "pry"
class Level < ActiveRecord::Base
  include ApplicationHelper

  validates :character_level, presence: true, numericality: {greater_than_or_equal_to: 0},
    uniqueness: {scope: :character_id}
  validates :ability_id, uniqueness: {scope: :character_id}
  validate :validate_increases
  validate :validate_character_id
  validate :validate_class_id
  validate :validate_ability_id

  belongs_to :character
  belongs_to :char_class, class_name: "CharacterClass", foreign_key: "class_id"
  belongs_to :ability

  def validate_increases
    check_stats_for_nil_or_0
    sum = 0
    stats.each {|stat| sum += self.send("#{stat}_increase").to_i}
    check_stats_for_levels_2_up(sum) if self.character_level.to_i > 1
    if self.character_level == 1
      errors.add(:stat_increases, "can only come from racial stat indices at level 1.") if sum != racial_increase_sum
    end
  end

  def check_stats_for_nil_or_0
    stats.each do |stat|
      if self.send("#{stat}_increase") == nil
        errors.add(:"#{stat}_increase", "cannot be blank.")
      elsif self.send("#{stat}_increase") < 0
        errors.add(:"#{stat}_increase", "must be greater than or equal to 0.")
      end
    end
  end

  def check_stats_for_levels_2_up(sum)
    errors.add(:stat_increases, "must add up to 5.") if sum != 5 + racial_increase_sum
    stats.each do |stat|
      if self.send("#{stat}_increase") > self.char_class.send("#{stat}_index") + racial_increase_for(stat)
        errors.add(:"#{stat}_increase", "cannot be greater than the class's stat index + the racial increase.")
      end
    end
  end

  def validate_character_id
    if self.character_id == nil
      errors.add(:character_id, "cannot be blank.")
    elsif !self.character
      errors.add(:character_id, "must correspond to an existing character.")
    end
  end

  def validate_class_id
    if self.class_id == nil
      errors.add(:class_id, "cannot be blank.")
    elsif !self.char_class
      errors.add(:class_id, "must correspond to an existing character class.")
    end
  end

  def validate_ability_id
    if self.ability_id == nil
      errors.add(:ability_id, "cannot be blank.")
    elsif !self.ability
      errors.add(:ability_id, "must correspond to an existing ability.")
    end
  end

  def racial_increase_for(stat)
    if self.character
      increase_values = self.character.race.send(:increase_levels_for, stat)
      adjusted_level = ((self.character_level + self.character.send("#{stat}_offset") - 1) % 15) + 1
      increase = (increase_values.include?(adjusted_level) ? 1 : 0)
    end
    increase
  end

  def racial_increase_sum
    sum = 0
    stats.each do |stat|
      sum += racial_increase_for(stat).to_i
    end
    sum
  end


  private

  def level_params
    params.require(:level).permit(:character_id, :class_id, :character_level,
      :ability_id, :fortitude_increase, :strength_increase, :mana_increase,
      :swiftness_increase, :intuition_increase)
  end
end
