class UpdateLevels < ActiveRecord::Migration
  def change
    add_column :characters, :base_level_id, :integer
    remove_column :levels, :class_level, :integer
    rename_column :levels, :char_class_id, :class_id
  end
end
