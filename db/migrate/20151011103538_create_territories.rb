class CreateTerritories < ActiveRecord::Migration
  def change
    create_table :territories do |t|
      t.string :name, uniqueness: true
      t.jsonb :zips, default: '{}'
      t.jsonb :zones, default: '{}'
      t.timestamps null: false
    end

    add_index  :territories, :name
  end
end

