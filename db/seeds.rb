# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Territory.create(name: 'test01', zips: {zips: %w(13149 13152 13151 13153 13157 13156 13159 13158 13160 13155 13154 13150).map(&:to_i)})

Territory.create(name: 'test02', zips: {zips: %w(05700 05701 05702 05703 05704 05705 05706 05707 05708 05709 05710 05711 05712 05713 05714 05715 05716 05717 05718 05719 05829 05830 05831 05832).map(&:to_i)})

Territory.create(name: 'test03', zips: {zips: %w(13100 13101 13102 13103 13104 13105 13106 13442 13443 13444 13445 13446 13447 13448 13449 13450 13451 13452 13453).map(&:to_i)})