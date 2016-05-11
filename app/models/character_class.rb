class CharacterClass < ActiveRecord::Base
  validates :name, presence: true
  validates :armor_type, presence: true
  validate :validate_indices
  validate :validate_entry_requirements

  has_and_belongs_to_many :abilities
  has_many :levels, inverse_of: :char_class, foreign_key: "class_id"
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

  private

  def character_class_params
    params.require(:character_class).permit(:name, :armor_type, :prestige, :entry_requirements,
      :fortitude_index, :strength_index, :mana_index, :swiftness_index, :intuition_index, :flavor_text)
  end
end
