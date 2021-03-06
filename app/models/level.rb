require "pry"
class Level < ActiveRecord::Base
  include ApplicationHelper
  extend ApplicationHelper

  validates :character_level, presence: true, numericality: {greater_than_or_equal_to: 0},
    uniqueness: {scope: :character_id}
  validates :ability_id, uniqueness: {scope: :character_id}
  validate :validate_increases
  validate :validate_foreign_keys

  belongs_to :character
  belongs_to :char_class, class_name: "CharacterClass"
  belongs_to :ability

  def validate_foreign_keys
    ["character", "ability", "char_class"].each do |key|
      if self.send("#{key}_id") == nil
        errors.add(:"#{key}_id", "cannot be blank.")
      elsif !self.send(key)
        errors.add(:"#{key}", "does not exist.")
      end
    end
    is_class_permitted? if self.character && self.char_level && self.char_class
    is_ability_permitted? if self.character && self.ability && self.char_class
  end

  def is_class_permitted?
    if self.char_level == 0 && self.char_class.prestige
      errors.add(:char_class, "cannot be a prestige class.")
    elsif self.char_level == 1 && self.char_class_id != self.character.base_class_id
      errors.add(:char_class, "must match the character's base class.")
    elsif self.char_level >= 2 && !self.char_class.prestige && self.char_class_id != self.character.base_class_id
      errors.add(:char_class, "cannot be a base class other than #{self.character.base_class.name}.")
    end
  end

  def is_ability_permitted?
    if !self.char_class.abilities.include?(self.ability)
      errors.add(:ability, "must be available for #{self.char_class.name}.")
    elsif self.character.levels.any? {|level| level != self && level.ability == self.ability}
      errors.add(:ability, "must not have already been learned by #{self.character.name}.")
    end
  end

  def validate_increases
    if stats.any? {|stat| self.send("#{stat}_increase") == nil}
      errors.add(:"stat_increases", "cannot be blank.")
    elsif stats.any? {|stat| self.send("#{stat}_increase") < 0}
      errors.add(:"stat_increases", "must be greater than or equal to 0.")
    elsif self.char_level && self.character && self.char_class
      stat_sum_valid?
      each_stat_valid? if self.char_level != 0
    end
  end

  def stat_sum_valid?
    expected = sum_for("racial") + (self.char_level >= 2 ? 5 : 0)
    if self.char_level != 0 && sum_for("increase") != expected
      errors.add(:stat_increases, "must add up to #{expected}.")
    end
  end

  def sum_for(type)
    sum = 0
    stats.each {|stat| sum += self.send("#{stat}_#{type}")}
    sum
  end

  def each_stat_valid?
    stats.any? do |stat|
      max = self.char_class.send("#{stat}_index") + self.send("#{stat}_racial")
      errors.add(:"#{stat}_increase", "cannot be greater than #{max}.") if self.send("#{stat}_increase") > max
    end
  end

  stats.each do |stat|
    define_method(:"#{stat}_racial") do
      increase_values = self.character.race.send(:increase_levels_for, stat)
      adjusted_level = ((self.char_level + self.character.send("#{stat}_offset") - 1) % 15) + 1
      increase_values.include?(adjusted_level) ? 1 : 0
    end
  end

  def char_level
    self.character_level
  end

  private

  def level_params
    params.require(:level).permit(:character_id, :char_class_id, :character_level,
      :ability_id, :fortitude_increase, :strength_increase, :mana_increase,
      :swiftness_increase, :intuition_increase)
  end
end
