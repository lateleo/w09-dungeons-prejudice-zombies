class CreateCharacterClasses < ActiveRecord::Migration
  def change
    create_table :character_classes do |t|
      t.string :name
      t.string :armor_type
      t.boolean :prestige
      t.text :entry_requirements
      t.integer :fortitude_index
      t.integer :strength_index
      t.integer :mana_index
      t.integer :swiftness_index
      t.integer :intuition_index
      t.text :flavor_text

      t.timestamps null: false
    end
  end
end
