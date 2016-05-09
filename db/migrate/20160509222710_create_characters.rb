class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :age
      t.integer :campaign_id
      t.integer :user_id
      t.integer :race_id
      t.integer :racial_bonus_id
      t.integer :fortitude_offset
      t.integer :strength_offset
      t.integer :mana_offset
      t.integer :swiftness_offset
      t.integer :intuition_offset
      t.text :description

      t.timestamps null: false
    end
  end
end
