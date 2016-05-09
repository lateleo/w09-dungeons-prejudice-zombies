class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :user_id
      t.text :description

      t.timestamps null: false
    end
  end
end
