class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name, uniqueness: true, null: false
      t.geometry :polygon
      t.timestamps null: false
    end
  end
end
