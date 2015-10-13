class Postcode < ActiveRecord::Base
  belongs_to :territory
  def vertexes
    self.polygon.to_s.match(/\(\((.*)\)\)/).captures.first.split(',').map { |e| lonlat = e.strip.split(' '); {longitude: lonlat.first, latitude: lonlat.last}  }
  end
end
