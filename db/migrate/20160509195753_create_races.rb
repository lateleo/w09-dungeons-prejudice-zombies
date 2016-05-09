class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :plural
      t.string :singular
      t.string :adjective
      t.integer :age_of_maturity
      t.integer :fortitude_index
      t.integer :strength_index
      t.integer :mana_index
      t.integer :swiftness_index
      t.integer :intuition_index
      t.text :description

      t.timestamps null: false
    end
  end
end
