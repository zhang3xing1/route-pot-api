class CreatePostcodes < ActiveRecord::Migration
  def change
    create_table :postcodes do |t|
      t.string :zip
      t.geometry :polygon
      t.timestamps null: false
    end

    add_index :postcodes, :zip
  end
end
