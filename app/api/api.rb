class API < Grape::API
  prefix 'api'
  format :json
  mount Tms::Measure
  mount Tms::Territories
  # mount Acme::Ping
  # mount Acme::Raise
  # mount Acme::Protected
  # mount Acme::Post

end