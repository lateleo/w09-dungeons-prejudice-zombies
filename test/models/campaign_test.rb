require 'test_helper'

class CampaignTest < ActiveSupport::TestCase

  test "should be valid when created normally" do
    @campaign = campaigns(:sea)
    assert(@campaign.valid?, "should be valid")
  end

  test "should be invalid without a name" do
    @campaign = campaigns(:sea)
    @campaign.name = nil
    refute(@campaign.valid?, "should be invalid without a name")
  end

  test "should be invalid without a description" do
    @campaign = campaigns(:sea)
    @campaign.description = nil
    refute(@campaign.valid?, "should be invalid without a description")
  end

  test "should filter dm_id properly" do
    @campaign = campaigns(:sea)
    @campaign.dm_id = nil
    refute(@campaign.valid?, "should be invalid without a dm_id")
    @campaign = campaigns(:cormyr)
    refute(@campaign.valid?, "should be invalid with a nonexistent dm")
    @campaign.dungeon_master = users(:rudolph)
    assert(@campaign.valid?, "should be valid with a duplicate dm_id")
  end

end
