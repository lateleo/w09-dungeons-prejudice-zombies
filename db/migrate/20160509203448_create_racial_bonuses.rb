class CreateRacialBonuses < ActiveRecord::Migration
  def change
    create_table :racial_bonuses do |t|
      t.string :name
      t.integer :race_id
      t.string :cooldown
      t.text :in_game_effect
      t.text :flavor_text

      t.timestamps null: false
    end
  end
end
