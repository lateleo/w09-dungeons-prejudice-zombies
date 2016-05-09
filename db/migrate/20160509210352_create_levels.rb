class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :character_id
      t.integer :char_class_id
      t.integer :character_level
      t.integer :class_level
      t.integer :ability_id
      t.integer :fortitude_increase
      t.integer :strength_increase
      t.integer :mana_increase
      t.integer :swiftness_increase
      t.integer :intuition_increase

      t.timestamps null: false
    end
  end
end
