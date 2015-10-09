class CreateParsedGpsTraces < ActiveRecord::Migration
  def change
    create_table :parsed_gps_traces do |t|
      t.date                          :delivery_date
      t.string                        :worker_id
      t.string                        :seq_id
      t.string                        :latitude
      t.string                        :longitude
      t.string                        :zipcode
      t.datetime                   :delivered_at
      t.string                        :invoicenumber
      t.integer                      :box_length
      t.integer                      :box_width
      t.integer                      :box_height
      t.timestamps null: false
    end

    add_index :parsed_gps_traces, :seq_id
    add_index :parsed_gps_traces, :zipcode
  end
end

# map = {
#   'DeliveryDate' => 'delivery_date',
#   'workerid' => 'worker_id',
#   'SeqID' => 'seq_id',
#   'LATITUDE' => 'latitude',
#   'LONGITUDE' => 'longitude',
#   'deliveredat' => 'delivered_at',
#   'length' => 'box_length',
#   'width' => 'box_width',
#   'height' => 'box_height'
# }

# re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
# # s = str.gsub(re, map)


# data = File.read("/Users/xing/Downloads/insert_bps_data.sql")
# # filtered_data = data.gsub("DeliveryDate", "delivery_date")
# filtered_data = data.gsub(re, map)
# # open the file for writing
# File.open("/Users/xing/Downloads/new_insert_bps_data.sql", "w") {|f| f.write(filtered_data)}
