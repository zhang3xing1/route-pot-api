Bundler.require(:default)

require './lib/tms'
include Tms

$geo = Geo.new

task default: :calculate_geo










#############################################################
#
#        version 1 - 20150818
#
#############################################################
desc 'Check geo file'
task :check_geo do
  # CSV HEAD
  # id,index,invoiceNumber,address,latitude,longitude,lastTrackingUpdatedAt
  puts 'Check geo file'
  $latest_file = last_modified_file('input', ext: 'csv')
  $time = Time.now.strftime("%H%M%S_%Y%m%d")
  $write_folder = $latest_file.pathmap("output/#{$time}_%n")

  mkdir_p "#{$write_folder}"
  mkdir_p "#{$write_folder}/tmp"
  cp $latest_file, $write_folder


  File.open('error.log','w') {|f| puts Time.now; puts '-'*100}

  puts "\tread #{$latest_file}"
  $geo.read_log $latest_file
  puts "\t#{$latest_file} have #{$geo.longitude_latitude.count} rows."
end


desc 'Calculate route for each coordinate'
task :calculate_geo => [:check_geo] do
  ll = $geo.longitude_latitude
  # cal_two_points(:kimgisa, 16)
  cal_two_points

  coordinate_files = Rake::FileList.new("#{$write_folder}/coordinate_*.csv")

  output_prefix = "#{$write_folder}/#{$time}"
  coordinates_csv = "#{output_prefix}_coordinates.csv"
  coordinates_mat_by_distance = "#{output_prefix}_distance.mat"
  coordinates_mat_by_duration = "#{output_prefix}_duration.mat"
  route_group_txt  =  "#{output_prefix}_route.txt"
  route_group_txt_reverse  =  "#{output_prefix}_route_reverse.txt"

  File.open(coordinates_csv, 'w') do |ff|
    ff.puts "pos1,pos2,distance,duration"
    coordinate_files.each {|csv| ff.puts File.readlines(csv)[1..-1]}
  end

  matrix = ExpenseMatrix.new(coordinates_csv)
  matrix.generate_matrix_by(:distance)
  # p matrix.matrix[1,2]
  # p matrix.matrix[2,1]
  File.open(coordinates_mat_by_distance,  "w") do |file|
    file.puts matrix.count
    matrix.to_a.each {|r| file.puts r.join(' ')}
  end

  matrix = ExpenseMatrix.new(coordinates_csv)
  matrix.generate_matrix_by(:duration)
  # p matrix.matrix[1,2]
  # p matrix.matrix[2,1]
  File.open(coordinates_mat_by_duration,  "w") do |file|
    file.puts matrix.count
    matrix.to_a.each {|r| file.puts r.join(' ')}
  end

  rm coordinate_files


  run_script = "./bin/tsp-or-tools #{coordinates_mat_by_distance}"
  puts "\n" + "-"*100
  route_output = `#{run_script}`
  if $?.success?
    routes_str = route_output.split(/\s/).last
    puts run_script
    puts route_output
    route_nodes =  routes_str.split('->')
    route_nodes_reverse = routes_str.split('->').reverse
    File.open(route_group_txt, "w") do |io|
      route_nodes.each_with_index do |route_no, index|
        io.puts index
        # puts '======'
        # p $geo.invoice_group_detail(route_no)
        # p $geo.invoice_group
        # p route_no
        # puts '======='
        # puts ''
        $geo.invoice_group_detail(route_no).each do |package|
          io.puts [ package[:name], package[:ordernumber], package[:invoicenumber], "#{package[:addr1]} #{package[:addr2]}"].join("\t") if !!package
        end
        io.puts "\n"
      end
    end

    # for reverse route
    p route_nodes
    p route_nodes_reverse
    File.open(route_group_txt_reverse, "w") do |io|
      route_nodes_reverse.each_with_index do |route_no, index|
        io.puts index
        puts '======'
        p $geo.invoice_group_detail(route_no)
        p $geo.invoice_group
        p route_no
        puts '======='
        puts ''
        $geo.invoice_group_detail(route_no).each do |package|
          io.puts [ package[:name], package[:ordernumber], package[:invoicenumber],"#{package[:addr1]} #{package[:addr2]}"].join("\t") if !!package
        end
        io.puts "\n"
      end
    end


    puts "\n"
    puts '-'*100
    puts 'Generate route static file'
    Rake::Task["route"].invoke(routes_str)

  else
    puts 'Shit happened in algorithm!'
  end
  puts "\n" + "-"*100
end


desc 'Prepare route geo info'
task :route, [:routes, :vehicle] => [:check_geo] do |task, args|
  puts 'Prepare route geo info'
  # puts "t, #{t}"
  # puts "Args were: #{args}"
  ll = $geo.longitude_latitude
  routes_str =  if args.to_hash.empty?
    "#{(0.upto(ll.count-1)).to_a.join('->')}->0"
  else
    args[:routes]
  end

  routes_str = routes_str.split('->').map{|node| node.to_i % ll.count}.join('->')

  puts '='*100
  puts "\tRoute is"
  puts "\t#{routes_str}\n"

  route_info_file = "#{$write_folder}/tmp/route_#{$time}.txt"
  icons_info_file = "#{$write_folder}/tmp/icons_#{$time}.txt"


  routes = write_route_var(routes_str, route_info_file, ll)
  icons  = write_icons_info(routes_str, icons_info_file, ll)

  # p routes

  b = binding
  b.local_variable_set(:routes, routes)
  b.local_variable_set(:icons, icons)

  template = File.read('data/route_template.erb')
  File.open("#{$write_folder}/route_#{$time}.html", 'w') {|f| f.puts ERB.new(template).result(b)}

  demo_template = File.read('data/route_demo_template.erb')
  File.open("#{$write_folder}/demo_route_#{$time}.html", 'w') {|f| f.puts ERB.new(demo_template).result(b)}



  reverse_route_str = routes_str.split('->').reverse.join('->')


  routes = write_route_var(reverse_route_str, route_info_file, ll)
  icons  = write_icons_info(reverse_route_str, icons_info_file, ll)

  # p routes

  b = binding
  b.local_variable_set(:routes, routes)
  b.local_variable_set(:icons, icons)

  template = File.read('data/route_template.erb')
  File.open("#{$write_folder}/route_#{$time}_reverse.html", 'w') {|f| f.puts ERB.new(template).result(b)}

  demo_template = File.read('data/route_demo_template.erb')
  File.open("#{$write_folder}/demo_route_#{$time}_reverse.html", 'w') {|f| f.puts ERB.new(demo_template).result(b)}


end

def get_binding(param)
  return binding
end

def last_modified_file(dir, options = {})
  Dir["#{dir}/**/*.#{options[:ext]}"].map { |p| [ p, File.mtime(p) ] }.max { |a,b| a[1] <=> b[1] }[0] rescue nil
end

def get_route(pos_start, pos_end, vehicle=:bicycle)
  nr = NaverMap.new(pos_start[:longitude], pos_start[:latitude], pos_end[:longitude], pos_end[:latitude])
  vehicle = :bicycle unless ![:bicycle, :car, :foot].include? vehicle

  nr.send(vehicle)

  JSON.parse nr.body[vehicle].to_json
end

def write_route_var(routes, file_routes, ll)
  f = File.open(file_routes, 'w')
  f.close
  routes_result = []

  routes = routes.split('->')
  routes.each_with_index do |item, index|
    next if index  == ll.count
    ll_count = ll.count
    pos_start, pos_end = ll[item.to_i], ll[routes[(index+1)%ll_count].to_i]

    puts "#{item} -> #{routes[index+1]}\t|\t#{index} of #{ll_count}"
    ss = get_route(pos_start, pos_end)

    next if ss.empty?

    steps =  ss["routes"].first['legs'].first['steps'].reduce(''){|result, e| result += "#{e["path"]} "}.split(' ').map{|e| res = e.split(','); [res[1], res[0]]}

    File.open(file_routes, 'a+') do |f|
      result = steps.reduce(''){|sum, e| sum += "new google.maps.LatLng(#{e.join(',')}),"}
      routes_result << result
      f.puts result
    end
  end
  routes_result
end

def write_icons_info(routes,icons_file, ll)
  # p ll
  # p 'll'
  results = []
  File.open(icons_file, "w") do |file|
    routes = routes.split('->')
    ll_count = ll.count
    routes.each_with_index do |item, index|
      result = "new google.maps.LatLng(#{ll[item.to_i % ll_count].values.join(',')}),\n"
      file.puts result
      results << result
    end
  end
  results
end

def cal_two_points(map_server = :kimgisa, first_row_number = 0, row_length= $geo.count, last_row_number = $geo.count - 1)
  addreses = $geo.longitude_latitude
  max_row_number = addreses.count - 1

  return if first_row_number > max_row_number
  row_length = [row_length , max_row_number - first_row_number].min

  last_row_number = first_row_number + row_length

  (first_row_number...last_row_number).each do |m|
    f = File.open("#{$write_folder}/coordinate_#{m.to_s.rjust(3,'0')}.csv", 'w')
    f.puts 'pos1, pos2, car_distance, car_duration, bicycle_distance, bicycle_duration,foot_distance, foot_duration'
    puts "#{m} of #{last_row_number} in two_points"

    sleep 0.5 if map_server == :naver


    threads = []

    (m..max_row_number).each do |n|
      pos_start, pos_end = addreses[m], addreses[n]
      next if m == n
      if pos_start[:longitude] == pos_end[:longitude] && pos_start[:latitude] == pos_end[:latitude]
        File.open('error.log','a+') do |f|
          f.puts $geo.items[m]
          f.puts $geo.items[n]
          f.puts "-----#{m} #{n}-----\n"
          puts "-----error in #{m} #{n}-----\n"
        end
        next
      end
      # puts "#{m} -> #{n}"

      if map_server == :naver
        nr = NaverMap.new(pos_start[:longitude], pos_start[:latitude], pos_end[:longitude], pos_end[:latitude])
        car, bicycle, foot = nr.car, nr.bicycle, nr.foot
        f.puts "#{m}, #{n}, #{car[0]}, #{car[1]}, #{bicycle[0]}, #{bicycle[1]}, #{foot[0]}, #{foot[1]} "
      end

      if map_server == :kimgisa

        # threads = []
        # 100.times do
        #   threads << Thread.new { Google.benchmark }
        # end
        # threads.each {|t| t.join}
        threads << Thread.new do
          kmap = KimgisaMap.new(pos_start[:longitude], pos_start[:latitude], pos_end[:longitude], pos_end[:latitude])
          kmap.request
          f.puts "#{m}, #{n}, #{kmap.distance[:xy]}, #{kmap.duration[:xy]}"
          f.puts "#{n}, #{m},  #{kmap.distance[:yx]}, #{kmap.duration[:yx]}"
        end
        # kmap = KimgisaMap.new(pos_start[:longitude], pos_start[:latitude], pos_end[:longitude], pos_end[:latitude])
        # kmap.request
        # f.puts "#{m}, #{n}, #{kmap.distance[:xy]}, #{kmap.duration[:xy]}"
        # f.puts "#{n}, #{m},  #{kmap.distance[:yx]}, #{kmap.duration[:yx]}"
      end
    end
    threads.each {|t| t.join}
    f.close
  end
  # [Finished in 1101.6s]  0~45
end

task :clean do
  rm_rf "output"
end

# route2 = '0->7->1->3->2->4->5->6->33->32->34->23->22->24->25->16->17->19->21->20->8->18->15->14->13->12->11->26->27->29->30->31->28->43->40->39->41->35->37->36->38->42->77->76->75->66->67->68->65->61->60->62->64->63->57->69->58->59->46->44->45->49->48->47->50->51->52->53->54->55->56->72->70->71->73->74->9->10->0'

# route3 = '0->1->3->2->7->6->4->5->33->32->34->23->22->24->21->20->19->25->16->17->18->15->14->13->12->11->26->27->31->30->29->28->39->41->43->40->36->38->37->35->42->77->76->75->68->67->66->65->61->62->60->64->63->57->58->69->59->46->44->45->49->48->47->50->51->52->53->54->56->55->72->70->71->73->74->10->9->8->0'
