class PlayerCampaignJoinTable < ActiveRecord::Migration
  def change
    create_join_table :player_campaigns, :players, table_name: :campaigns_users
  end
end
