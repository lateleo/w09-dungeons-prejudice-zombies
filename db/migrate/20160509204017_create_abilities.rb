class CreateAbilities < ActiveRecord::Migration
  def change
    create_table :abilities do |t|
      t.string :name
      t.string :cooldown
      t.text :in_game_effect
      t.text :flavor_text

      t.timestamps null: false
    end
  end
end
