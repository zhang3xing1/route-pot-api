module Tms
  class Geo
    attr_accessor :items
    attr_reader :invoice_group

    def initialize
      @n = 0
    end

    def read_log(log)
      # csv file head
      # id,index,invoiceNumber,address,latitude,longitude,lastTrackingUpdatedAt

      # name  addr1 addr2 longitude latitude  zip invoiceNumber orderNumber deliverystatus  targetWorkplaceId campid  workerid
      items = SmarterCSV.process log

      # 서울시 송파구 송파대로 55 동남권물류단지 E동 지하1층
      #   "x": "127.1237153",
      # "y": "37.4742485",

      items.select!{|item| item[:longitude].class == Float &&  item[:latitude].class == Float}

      items_detail = {}
      # items_detail[:camp] = ({addr1: '서울시 송파구 송파대로 55 동남권물류단지 E동 지하1층', longitude: 127.1237153, latitude: 37.4742485})

      squence_no = 0

      @items_map_by_invoiceno = {}

      items.each do |item|
        lonlat = "#{item[:longitude]}_#{item[:latitude]}"
        items_detail[lonlat] ||= {}
        items_detail[lonlat][:longitude] = item[:longitude]
        items_detail[lonlat][:latitude] = item[:latitude]
        items_detail[lonlat][:invoice_group] ||= []
        items_detail[lonlat][:invoice_group] << item[:invoicenumber]

        @items_map_by_invoiceno["invoice_#{item[:invoicenumber]}" ] = item

      end

      camp  = {longitude: 127.1237153, latitude: 37.4742485,invoice_group: ['camp'] }

      @items = []
      @items.push camp

      @items += items_detail.values

      @invoice_group = @items.map{|item| item[:invoice_group] }
      puts "@items_count = #{@items.count}"

      # puts @invoice_group

      @items_map_idby_invoiceno
    end

    def take(n)
      @n = n
      @items.take(n)
    end

    def count
      @items.count
    end

    def invoice_group_by id
      id_num = id.to_i % count
      @items[id_num][:invoice_group] if id_num < @items.count
    end

    def invoice_group_detail id
      invoices = invoice_group_by id
      # p invoices
      invoices.map {|invoice| item_by invoice } if !!invoices
    end

    def item_by invoicenumber
      @items_map_by_invoiceno["invoice_#{invoicenumber}"]
    end

    def longitude_latitude(n=@items.count)
      # [{:longitude=>127.126813522, :latitude=>37.4318501516},
      # @items.take(n).map{|item| {latitude: item[:latitude], longitude: item[:longitude]}}

      @items.take(n).map{|item| {latitude: item[:latitude], longitude: item[:longitude]}}
    end

    def to_s
      'This is GEO2'
    end

  end
end


module Tms
  # Slim version string
  # @api public
  VERSION = '0.1.0'
end
