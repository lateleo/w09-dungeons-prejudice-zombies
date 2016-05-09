class CharacterClass < ActiveRecord::Base
  validates :name
  validates :armor_type
  validate :validate_indices
  validate :validate_entry_requirements

  has_and_belongs_to_many :abilities
  has_many :levels, as: :char_class
  has_many :characters, through: :levels

  def validate_indices
    sum = fortitude_index + strength_index + mana_index + swiftness_index + intuition_index
    errors.add(:stat_indices, "must add up to 8.") if sum != 8
  end

  def validate_entry_reqs
    if self.prestige && self.entry_reqs == nil
      errors.add(:entry_requirements, "are necessary for Prestige Classes.")
    elsif !self.prestige && self.entry_reqs != nil
      errors.add(:entry_requirements, "are not allowed for Base Classes.")
    end
  end
end
