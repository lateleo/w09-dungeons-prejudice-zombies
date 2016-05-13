require File.expand_path('../../helpers/application_helper', __FILE__)
require "pry"

class CharacterClass < ActiveRecord::Base
  include ApplicationHelper

  validates_with UniversalValidator
  validates :armor_type, presence: true
  validate :validate_indices
  validate :validate_prestige


  has_and_belongs_to_many :abilities
  has_many :levels, inverse_of: :char_class, foreign_key: "class_id"
  has_many :characters, through: :levels

  def validate_indices
    check_index_sum
    stats.each do |stat|
      errors.add(:"#{stat}_index", "cannot be blank.") if self.send("#{stat}_index") == nil
      if self.send("#{stat}_index") > 4 || self.send("#{stat}_index") < 0
        errors.add(:"#{stat}_index", "must be between 0 and 4 inclusive.")
      end
    end
  end

  def check_index_sum
    sum = 0
    stats.each do |stat|
      sum += self.send("#{stat}_index").to_i
    end
    errors.add(:stat_indices, "must add up to 8.") if sum != 8
  end

  def validate_prestige
    if self.prestige == nil
      errors.add(:prestige, "can't be blank.")
    elsif self.prestige
      errors.add(:entry_requirements, "are necessary for Prestige Classes.") if self.entry_requirements == nil
    elsif self.prestige == false
      errors.add(:entry_requirements, "are not allowed for Base Classes.") if self.entry_requirements != nil
    end
  end

  private

  def character_class_params
    params.require(:character_class).permit(:name, :armor_type, :prestige, :entry_requirements,
      :fortitude_index, :strength_index, :mana_index, :swiftness_index, :intuition_index, :flavor_text)
  end
end
