class RenameUserIdInCharacters < ActiveRecord::Migration
  def change
    rename_column :characters, :user_id, :player_id
  end
end
