class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: {case_sensitive: false}

  # The association for the campaigns that a user is the DM for.
  has_many :dm_campaigns, class_name: "Campaign", foreign_key: "dm_id"
  # The association for the characters of the players in a user's dm_campaigns.
  has_many :campaign_characters, through: :campaigns, class_name: "Character"
  # The association for the campaigns in which the user is a player. See
  # campaign.rb for more details.
  has_and_belongs_to_many :player_campaigns, class_name: "Campaign",
    foreign_key: "player_id",
    association_foreign_key: "player_campaign_id"
  # The characters that the user plays in the campaigns in which they are a
  # player. These are distinct from campaign_characters, as the "owner" of a
  # character is the player, not the DM.
  has_many :player_characters, class_name: "Character", foreign_key: "player_id"


end
