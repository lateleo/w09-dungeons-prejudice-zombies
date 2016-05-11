class Campaign < ActiveRecord::Base
  validates :name, presence: true
  validates :dm_id, presence: true
  validates :description, presence: true

  # This is the association for the user that is DMing the campaign. There is
  # only one, and it is required at creation.
  belongs_to :dungeon_master, class_name: "User", foreign_key: "dm_id"

  # This is the association for the users that are the players in the campaign.
  # They can belong to multiple campaigns, but are referred to as "players" here
  # and in the join table, and a campaign that a player belongs to is referred to
  # as their "player campaign", to distinguish between players and DMs and their
  # respective relationships with campaigns.
  has_and_belongs_to_many :players, class_name: "User",
    foreign_key: "player_campaign_id",
    association_foreign_key: "player_id"
  has_many :characters

  private

  def campaign_params
    params.require(:campaign).permit(:name, :dm_id, :description)
  end
end
