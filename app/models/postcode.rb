class Postcode < ActiveRecord::Base
  belongs_to :territory
  def vertexes
    self.polygon.to_s.match(/\(\((.*)\)\)/).captures.first.split(',').map { |e| lonlat = e.strip.split(' '); {longitude: lonlat.first, latitude: lonlat.last}  }
  end

  def centroid
    res = Postcode.connection.execute %Q{SELECT ST_AsText(ST_Centroid('#{self.polygon.to_s}'));}
    #"POINT(127.170013617607 37.4620578958111)"
    format_point(res.getvalue(0,0))
  end

  def zip_body
    {name: self.zip, centroid: self.centroid, vertexes: self.vertexes, isOriginal: 'true'}
  end

  private
  def format_point(point_from_db)
    lonlat = self.polygon.to_s.match(/\(\((.*)\)\)/).captures.first.split(' ')
    {longitude: lonlat.first, latitude: lonlat.last}
  end


end
