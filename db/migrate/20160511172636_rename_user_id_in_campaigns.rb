class RenameUserIdInCampaigns < ActiveRecord::Migration
  def change
    rename_column :campaigns, :user_id, :dm_id
  end
end
