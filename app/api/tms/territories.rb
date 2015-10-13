module Tms
  class Territories < Grape::API
    desc 'single zip polygon'

    get 'zips/:zip' do
      zip = params[:zip].to_i
      single_zip =Postcode.where(zip: zip).first
      single_zip.zip_body
    end


    get 'territories/:name' do
        single_territory =Territory.where(name: params[:name]).first
        {name: params[:name], zips: single_territory.zip_body}
    end

  end
end




# curl -H "Content-Type: application/json" -X POST -d '{"start_lng" : 126.895041, "start_lat": 37.523201, "end_lng": 126.79572769918, "end_lat": 37.5277526836272}' http://localhost:3000/api/car

# curl -H "Content-Type: application/json" -X POST -d '{"start_lng" : 126.895041, "start_lat": 37.523201, "end_lng": 126.79572769918, "end_lat": 37.5277526836272}' http://localhost:3000/api/bicycle

# curl -H "Content-Type: application/json" -X POST -d '{"start_lng" : 126.895041, "start_lat": 37.523201, "end_lng": 126.79572769918, "end_lat": 37.5277526836272}' http://localhost:3000/api/foot
