require File.expand_path('../../helpers/application_helper', __FILE__)

class CharacterClass < ActiveRecord::Base
  validates_with UniversalValidator
  validates :armor_type, presence: true
  validates :prestige, presence: true
  validate :validate_indices
  validate :validate_entry_reqs

  has_and_belongs_to_many :abilities
  has_many :levels, inverse_of: :char_class, foreign_key: "class_id"
  has_many :characters, through: :levels

  def validate_indices
    sum = 0
    stats.each do |stat|
      sum += self.send("#{stat}_index")
      if self.send("#{stat}_index") >= 4 || self.send("#{stat}_index") <= 0
        erros.add(:"#{stat}_index", "must be between 0 and 4 inclusive.")
      end
    end
    errors.add(:stat_indices, "must add up to 8.") if sum != 8
  end

  def validate_entry_reqs
    if self.prestige && self.entry_reqs == nil
      errors.add(:entry_requirements, "are necessary for Prestige Classes.")
    elsif !self.prestige && self.entry_reqs != nil
      errors.add(:entry_requirements, "are not allowed for Base Classes.")
    end
  end

  private

  def character_class_params
    params.require(:character_class).permit(:name, :armor_type, :prestige, :entry_requirements,
      :fortitude_index, :strength_index, :mana_index, :swiftness_index, :intuition_index, :flavor_text)
  end
end
