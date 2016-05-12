class RacesPluralToName < ActiveRecord::Migration
  def change
    rename_column :races, :plural, :name
  end
end
