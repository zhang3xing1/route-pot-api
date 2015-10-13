class MakePostcodeZipUnique < ActiveRecord::Migration
  def change
    change_column :postcodes, :zip, :string, null: :false, uniqueness: true
  end
end
