# https://openapi.kimgisa.co.kr/search?key=ecf08384fb97416b8a363103a799e557&coordinate=wgs84&sname=startaddress&sx=126.895041&sy=37.523201&ename=endaddress&ex=126.89572769918&ey=37.5277526836272

# require 'nokogiri'
# require 'open-uri'

module Tms
  class KimgisaMap
    attr_accessor :start_x, :start_y, :end_x, :end_y, :duration, :distance, :api_car, :body

    def initialize(start_x, start_y, end_x, end_y)
      @start_x, @start_y, @end_x, @end_y = start_x.to_s, start_y.to_s, end_x.to_s, end_y.to_s

      @key = 'ecf08384fb97416b8a363103a799e557'

      @api = %Q[https://openapi.kimgisa.co.kr/search?key=#{@key}&coordinate=wgs84&sname=startaddress&sx=#{@start_x}&sy=#{@start_y}&ename=endaddress&ex=#{@end_x}&ey=#{@end_y}]

      @api2= %Q[https://openapi.kimgisa.co.kr/search?key=#{@key}&coordinate=wgs84&sname=startaddress&sx=#{@end_x}&sy=#{@end_y}&ename=endaddress&ex=#{@start_x}&ey=#{@start_y}]
    end

    def request
      @doc = Nokogiri::XML(open @api)
      @doc2 = Nokogiri::XML(open @api2)
    end

    def distance
      xy_distance = @doc.xpath("//ERR_CODE").text== '000' ? @doc.xpath("//DISTANCE").text : '0'
      yx_distance = @doc2.xpath("//ERR_CODE").text == '000' ? @doc2.xpath("//DISTANCE").text : '0'

      {xy: xy_distance, yx: yx_distance}
    end

    def duration
      xy_time = @doc.xpath("//ERR_CODE").text== '000' ? @doc.xpath("//TIME").text : '0'
      yx_time = @doc2.xpath("//ERR_CODE").text == '000' ? @doc2.xpath("//TIME").text : '0'

      {xy: xy_time, yx: yx_time}
    end
  end
end
