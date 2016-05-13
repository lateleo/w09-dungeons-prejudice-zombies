require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  test "should be valid with and without flavor_text" do
    @ability = abilities(:crusader_strike)
    assert(@ability.valid?, "should be valid without flavor_text")
    @ability.flavor_text = "It's really strong."
    assert(@ability.valid?, "should be valid with flavor_text")
  end

  test "should be invalid without a name" do
    @ability = abilities(:crusader_strike)
    @ability.name = nil
    refute(@ability.valid?, "should be invalid without a name")
  end

  test "should be invalid without a cooldown" do
    @ability = abilities(:crusader_strike)
    @ability.cooldown = nil
    refute(@ability.valid?, "should be invalid without a cooldown")
  end

  test "should be invalid without an in_game_effect" do
    @ability = abilities(:crusader_strike)
    @ability.in_game_effect = nil
    refute(@ability.valid?, "should be invalid without an in_game_effect")
  end

  test "should filter duplicate attributes properly" do
    @ability = abilities(:crusader_strike)
    @ability.save
    @dup = @ability.dup
    [Ability, CharacterClass, Character, Race, RacialBonus].each do |model|
      @dup.name = model.first.name
      refute(@dup.valid?, "should not allow a duplicate name")
      assert(@dup.errors[:name], "should have an error under :name")
    end
    @dup.name = "duplicate"
    assert(@dup.valid?, "should be valid with unique name but otherwise redundant attributes")
  end

end
