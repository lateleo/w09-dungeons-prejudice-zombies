class AddJoinTables < ActiveRecord::Migration
  def change
    create_join_table :abilities, :character_classes
  end
end
