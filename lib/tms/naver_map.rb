module Tms
  class NaverMap
    attr_accessor :start_x, :start_y, :end_x, :end_y, :duration, :distance, :api_car, :body

    def initialize(start_x, start_y, end_x, end_y)
      @start_x, @start_y, @end_x, @end_y = start_x.to_s, start_y.to_s, end_x.to_s, end_y.to_s
      @api_car =     "http://map.naver.com/spirra/findCarRoute.nhn?route=route3&output=json&result=web3&coord_type=latlng&search=2&car=0&mileage=12.4&start=#{@start_x}%2C#{@start_y}%2C%EC%B2%AD%EC%B6%98%EA%B7%B9%EC%9E%A5&destination=#{@end_x}%2C#{@end_y}%2C%EC%A0%95%EB%8F%99%EC%95%84%ED%8C%8C%ED%8A%B8&via="
      @api_bicycle = "http://map.naver.com/spirra/findCarRoute.nhn?call=route3&output=json&search=8&result=web3&coord_type=latlng&start=#{@start_x}%2C#{@start_y}%2C%EC%B2%AD%EC%B6%98%EA%B7%B9%EC%9E%A5&destination=#{@end_x}%2C#{@end_y}%2C%EC%A0%95%EB%8F%99%EC%95%84%ED%8C%8C%ED%8A%B8&via="
      @api_foot =    "http://map.naver.com/findroute2/findWalkRoute.nhn?call=route2&output=json&coord_type=latlng&search=0&start=#{@start_x}%2C#{@start_y}%2C%EC%B2%AD%EC%B6%98%EA%B7%B9%EC%9E%A5&destination=#{@end_x}%2C#{@end_y}%2C%EC%A0%95%EB%8F%99%EC%95%84%ED%8C%8C%ED%8A%B8"
      @body = {}

      puts start_x, start_y, end_x, end_y

    end

    #####
    def car_api
      r = @body[:car] = HTTParty.get(@api_car)
      p @api_car
      @status = '200'
      if r["routes"].class == Array
        @distance, @duration = r["routes"].first["summary"]["distance"], r["routes"].first["summary"]["duration"]
      else
        begin
          r = JSON.parse(r.to_s)
          @distance, @duration = r["result"]["summary"]["totalDistance"], r["result"]["summary"]["totalTime"]*60
        rescue JSON::ParserError => e
          @status = '503'
          @distance, @duration, @body[:car] = 0, 0, {}
        end
      end
      {status: @status, distance: @distance.to_s, duration: @duration.to_s}
    end


    def bicycle_api
      r = @body[:bicycle] = HTTParty.get(@api_bicycle)
      @status = '200'
      if r["routes"].class == Array
        @distance, @duration = r["routes"].first["summary"]["distance"], r["routes"].first["summary"]["duration"]
      else
        begin
          r = JSON.parse(r.to_s)
          @distance, @duration = r["result"]["summary"]["totalDistance"], r["result"]["summary"]["totalTime"]*60
        rescue JSON::ParserError => e
          @status = '503'
          @distance, @duration, @body[:bicycle] = 0, 0, {}
        end
      end
      {status: @status, distance: @distance.to_s, duration: @duration.to_s}
    end


    def foot_api
      r = @body[:foot] = HTTParty.get(@api_foot)
      @status = '200'
      if r["routes"].class == Array
        @distance, @duration = r["routes"].first["summary"]["distance"], r["routes"].first["summary"]["duration"]
      else
        begin
          r = JSON.parse(r.to_s)
          if !!r["result"]["summary"]["totalDistance"]
            @distance, @duration = r["result"]["summary"]["totalDistance"], r["result"]["summary"]["totalTime"]*60
          else
            @status = '503'
            @distance, @duration, @body[:foot] = 0, 0, {}
          end
        rescue JSON::ParserError => e
          @status = '503'
          @distance, @duration, @body[:foot] = 0, 0, {}
        end
      end
      {status: @status, distance: @distance.to_s, duration: @duration.to_s}
    end
    #####


    def car
      r = @body[:car] = HTTParty.get(@api_car)
      # @distance, @duration = r["routes"].first["summary"]["distance"], r["routes"].first["summary"]["duration"]
      if r["routes"].class == Array
        @distance, @duration = r["routes"].first["summary"]["distance"], r["routes"].first["summary"]["duration"]
      else
        begin
          r = JSON.parse(r.to_s)
          @distance, @duration = r["result"]["summary"]["totalDistance"], r["result"]["summary"]["totalTime"]*60
        rescue JSON::ParserError => e
          puts  'JSON::ParserError resuce! in car'
          puts "!!!"
          puts r.to_s
          puts "!!!"
          @distance, @duration, @body[:car] = 0, 0, {}
        end
      end
    end

    def bicycle
      r = @body[:bicycle] = HTTParty.get(@api_bicycle)

      if r["routes"].class == Array
        @distance, @duration = r["routes"].first["summary"]["distance"], r["routes"].first["summary"]["duration"]
      else
        begin
          r = JSON.parse(r.to_s)
          @distance, @duration = r["result"]["summary"]["totalDistance"], r["result"]["summary"]["totalTime"]*60
        rescue JSON::ParserError => e
          puts  'JSON::ParserError resuce! in bicycle'
          puts "!!!"
          puts r.to_s
          puts "!!!"
          @distance, @duration, @body[:bicycle] = 0, 0, {}
        end
      end
    end

    def foot
      r = @body[:foot] = HTTParty.get(@api_foot)
      if r["routes"].class == Array
        @distance, @duration = r["routes"].first["summary"]["distance"], r["routes"].first["summary"]["duration"]
      else
        begin
          r = JSON.parse(r.to_s)
          if !!r["result"]["summary"]["totalDistance"]
            @distance, @duration = r["result"]["summary"]["totalDistance"], r["result"]["summary"]["totalTime"]*60
          else
            @distance, @duration, @body[:foot] = 0, 0, {}
          end
        rescue JSON::ParserError => e
          puts  'JSON::ParserError resuce! in foot'
          puts "!!!"
          puts r.to_s
          puts "!!!"
          @distance, @duration, @body[:foot] = 0, 0, {}
        end
      end
    end
  end
end
