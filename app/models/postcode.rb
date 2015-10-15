class Postcode < ActiveRecord::Base
  belongs_to :territory
  def vertexes
    self.polygon.to_s.match(/\(\((.*)\)\)/).captures.first.split(',').map { |e| lonlat = e.strip.split(' '); {longitude: lonlat.first, latitude: lonlat.last}  }
  end

  def centroid
    format_point(Postcode.where(zip: self.zip).first.polygon.centroid)
  end

  def zip_body
    {name: self.zip, centroid: self.centroid, vertexes: self.vertexes, isOriginal: 'true'}
  end

  private
  def format_point(point_from_db)
    lonlat = point_from_db.to_s.match(/\((.*)\)/).captures.first.split(' ')
    {longitude: lonlat.first, latitude: lonlat.last}
  end


end
