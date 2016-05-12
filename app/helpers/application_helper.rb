module ApplicationHelper
  def stats
    ["fortitude", "strength", "mana", "swiftness", "intuition"]
  end

  def a_an(word)
    word.upcase =~ /\A[AEIOU]/ ? "an" : "a"
  end

  def class_name_to_string(class_name)
    class_name.gsub(/(?<=\p{L})(\p{Lu})/, $1)
  end
end

class UniversalValidator < ActiveModel::Validator
  def validate(record)
    models = [Ability, CharacterClass, Character, Race, RacialBonus]
    models.select!{|m| m.where(name: record.name).any?{|obj| obj != record}}
    if models.any?
      record.errors[:name] << "is already the name of #{a_an(models[0].to_s)}
      #{class_name_to_string(models[0])}."
    else
      (record.errors[:name] << "cannot be blank.") if !record.name?
    end
  end
end
