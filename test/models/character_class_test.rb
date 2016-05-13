require 'test_helper'

class CharacterClassTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "should be valid with and without description" do
    @character_class = character_classes(:one)
    assert(@character_class.valid?, "should be valid without flavor_text")
    @character_class.flavor_text = "Righteous."
    assert(@character_class.valid?, "should be valid with flavor_text")
  end

  test "should be invalid without a name" do
    @character_class = character_classes(:one)
    @character_class.name = nil
    refute(@character_class.valid?, "should be invalid without a name")
  end

  test "should be invalid without an armor_type" do
    @character_class = character_classes(:one)
    @character_class.armor_type = nil
    refute(@character_class.valid?, "should be invalid without an armor_type")
  end

  test "should be invalid without a prestige" do
    @character_class = character_classes(:one)
    @character_class.prestige = nil
    refute(@character_class.valid?, "should be invalid without a prestige")
  end

  test "should require and allow entry_reqs only when prestige is true" do
    @character_class = character_classes(:one)
    @character_class.entry_requirements = "Character level: 6"
    refute(@character_class.valid?, "should be invalid with entry_reqs when prestige is false")
    @character_class = character_classes(:two)
    assert(@character_class.valid?, "should be valid with entry_reqs when prestige is true")
    @character_class.entry_requirements = nil
    refute(@character_class.valid?, "should be invalid without entry_reqs when prestige is true")
  end


  test "should be invalid without correct stat_indices" do
    @character_class = character_classes(:one)
    stats.each do |stat|
      original = @character_class.send("#{stat}_index")
      @character_class.send("#{stat}_index=", nil)
      refute(@character_class.valid?, "should be invalid with a nil stat index")
      @character_class.send("#{stat}_index=", original+1)
      refute(@character_class.valid?, "should be invalid with a stat index sum of 9")
      @character_class.send("#{stat}_index=", original-1)
      refute(@character_class.valid?, "should be invalid with a stat index sum of 7")
      @character_class.send("#{stat}_index=", original)
    end
    @character_class.mana_index = 4
    @character_class.strength_index = -4
    refute(@character_class.valid?, "should be invalid with stats outside of -3 to 3")
  end

  test "should filter duplicate attributes properly" do
    @character_class = character_classes(:one)
    @character_class.save
    @dup = @character_class.dup
    [:abilities, :character_classes, :characters, :races, :racial_bonuses].each do |model|
      @dup.name = send(model, :one).name
      refute(@dup.valid?, "should not allow a duplicate name")
      assert(@dup.errors[:name], "should have an error under :name")
    end
    @dup.name = "duplicate"
    assert(@dup.valid?, "should be valid with unique name but otherwise redundant attributes")
  end

end
