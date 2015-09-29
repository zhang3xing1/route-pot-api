module Tms
  class Geo2
    def read_csv csv_file
      @original_items  = SmarterCSV.process csv_file
      @original_items.map! {|item| item[:lonlat] = "lonlat_#{item[:longitude]}_#{item[:latitude]}"; item}
      # name,addr1,addr2,longitude,latitude,zip,invoicenumber,ordernumber,deliverystatus,targetworkplaceId,campid
      # p @original_items
      @items = {}
      @items[:lonlat] = @original_items.group_by {|item| item[:lonlat]}

    end

    def count
      @original_items.count
    end

    def collections_by(key)
      @items[key]
    end

    def get_collection_by(option)
      key, value = option[:key], option[:value]
      @items[key][value]
    end

    ### for compatibility for class Geo

    def longitude_latitude
      @items[:lonlat].values.map{|group| group.first }
    end

  end
end


