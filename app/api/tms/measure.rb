module Tms
  class Measure < Grape::API
    # nr  = Tms::NaverMap.new(126.895041, 126.895041, 126.89572769918, 126.89572769918)
    # nr  = Tms::NaverMap.new(126.895041, 37.523201, 126.89572769918, 37.5277526836272)
    desc 'Naver Map Api'
    post :car do
      nr  = Tms::NaverMap.new(params[:start_lng], params[:start_lat],params[:end_lng], params[:end_lat])
      { car: nr.car_api }
    end

    post :bicycle do
      nr  = Tms::NaverMap.new(params[:start_lng], params[:start_lat],params[:end_lng], params[:end_lat])
      { bicycle: nr.bicycle_api }
    end

    post :foot do
      nr  = Tms::NaverMap.new(params[:start_lng], params[:start_lat],params[:end_lng], params[:end_lat])
      { foot: nr.foot_api }
    end
  end
end




# curl -H "Content-Type: application/json" -X POST -d '{"start_lng" : 126.895041, "start_lat": 37.523201, "end_lng": 126.79572769918, "end_lat": 37.5277526836272}' http://localhost:3000/api/car

# curl -H "Content-Type: application/json" -X POST -d '{"start_lng" : 126.895041, "start_lat": 37.523201, "end_lng": 126.79572769918, "end_lat": 37.5277526836272}' http://localhost:3000/api/bicycle

# curl -H "Content-Type: application/json" -X POST -d '{"start_lng" : 126.895041, "start_lat": 37.523201, "end_lng": 126.79572769918, "end_lat": 37.5277526836272}' http://localhost:3000/api/foot
