class UpdateLevels < ActiveRecord::Migration
  def change
    remove_column :levels, :class_level, :integer
  end
end
