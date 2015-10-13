class Territory < ActiveRecord::Base

  def zip_body
    self.zips['zips']
    Postcode.where(zip:  self.zips['zips'] || []).map { |zip| {name:zip.zip, vertexes: zip.vertexes, isOriginal: 'true'} }
  end

end


#<Territory:0x007ff61a71bc28
# id: 2,
# name: "test01",
# zips:
#  {"zips"=>[13149, 13152, 13151, 13153, 13157, 13156, 13159, 13158, 13160, 13155, 13154, 13150]},
# zones: {},
# created_at: Sun, 11 Oct 2015 12:09:53 UTC +00:00,
# updated_at: Sun, 11 Oct 2015 12:09:53 UTC +00:00>
