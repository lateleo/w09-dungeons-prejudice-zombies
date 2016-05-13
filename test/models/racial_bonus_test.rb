require 'test_helper'

class RacialBonusTest < ActiveSupport::TestCase

  test "should be valid with and without flavor_text" do
    @racial_bonus = racial_bonuses(:sheer_luck)
    assert(@racial_bonus.valid?, "should be valid without flavor_text")
    @racial_bonus.flavor_text = "They're super lucky."
    assert(@racial_bonus.valid?, "should be valid with flavor_text")
  end

  test "should be invalid without a name" do
    @racial_bonus = racial_bonuses(:sheer_luck)
    @racial_bonus.name = nil
    refute(@racial_bonus.valid?, "should be invalid without a name")
  end

  test "should be invalid without a correct race_id" do
    @racial_bonus = racial_bonuses(:sheer_luck)
    @racial_bonus.race = nil
    refute(@racial_bonus.valid?, "should be invalid without a race_id")
    @racial_bonus.race_id = 9
    refute(@racial_bonus.valid?, "should be invalid with a race_id for a non-existent race")
  end

  test "should be invalid without a cooldown" do
    @racial_bonus = racial_bonuses(:sheer_luck)
    @racial_bonus.cooldown = nil
    refute(@racial_bonus.valid?, "should be invalid without a cooldown")
  end

  test "should be invalid without an in_game_effect" do
    @racial_bonus = racial_bonuses(:sheer_luck)
    @racial_bonus.in_game_effect = nil
    refute(@racial_bonus.valid?, "should be invalid without an in_game_effect")
  end

  test "should filter duplicate attributes properly" do
    @racial_bonus = racial_bonuses(:sheer_luck)
    @racial_bonus.save
    @dup = @racial_bonus.dup
    [Ability, CharacterClass, Character, Race, RacialBonus].each do |model|
      @dup.name = model.first.name
      refute(@dup.valid?, "should not allow a duplicate name")
      assert(@dup.errors[:name], "should have an error under :name")
    end
    @dup.name = "duplicate"
    assert(@dup.valid?, "should be valid with unique name but otherwise redundant attributes")
  end

end
