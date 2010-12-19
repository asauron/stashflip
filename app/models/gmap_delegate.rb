#gem install cornflakesuperstar-polymaps
#script/plugin install git://github.com/cornflakesuperstar/polymaps.git
class GmapDelegate < ActiveRecord::Base
  attr_accessor :map
  #in development. by jin-su
  def index
    business_list = params[:businesses]
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    first_ele = business_list[0]
    @map.center_zoom_init([first_ele["latitude"], first_ele["longitude"]], 10)
    @map.overlay_init(GMarker.new([first_ele["latitude"], first_ele["longitude"]], :title => first_ele["name"], :info_window => first_ele["address1"]))
  end

  #pass in a list that starts from the original business_list[1..-1]
  def update
    business_list = params[:businesses][1..-1]
    # loop through each element and create a GMarker
    @markers = []
    business_list.each do |business|
      @markers << GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => business["address1"])
      #@map.add_overlay(GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => business["address1"]))
    end

    #apply the markers
    @markers.each do |marker|
      @map.add_overlay(marker)
    end

  end

  def self.getGMap(business_list)

    #call index function

    first_business = business_list[0]
    map = GMap.new("map_div")
    map.control_init(:large_map => true, :map_type => true)

    map.center_zoom_init([first_business["latitude"], first_business["longitude"]], 12)

    #######################################################
    GmapDelegate.initialize_heat_icons(map)
    restaurant_icon = GIcon.new(
      :image => "/images/strikefood.png",
      :icon_anchor => GPoint.new(16,37),
      :info_window_anchor => GPoint.new(9,2)
    )
    #######################################################
    #call update function
    # loop through each element and create a GMarker
    @markers = []
    business_list.each_with_index do |business, i|
      weight = business["beatmap_rating"]
      if weight == 15 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_15, :clickable => false, :draggable => false)
      elsif weight == 14 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window =>info_window_for_biz(business, i), :icon => @@heat_icon_14, :clickable => false, :draggable => false)
      elsif weight == 13 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_13, :clickable => false, :draggable => false)
      elsif weight == 12 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_12, :clickable => false, :draggable => false)
      elsif weight == 11 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window =>info_window_for_biz(business, i) , :icon => @@heat_icon_11, :clickable => false, :draggable => false)
      elsif weight == 10 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_10, :clickable => false, :draggable => false)
      elsif weight == 9 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window =>info_window_for_biz(business, i) , :icon => @@heat_icon_9, :clickable => false, :draggable => false)
      elsif weight == 8 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_8, :clickable => false, :draggable => false)
      elsif weight == 7 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_7, :clickable => false, :draggable => false)
      elsif weight == 6 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window =>info_window_for_biz(business, i) , :icon => @@heat_icon_6, :clickable => false, :draggable => false)
      elsif weight == 5 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_5, :clickable => false, :draggable => false)
      elsif weight == 4 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_4, :clickable => false, :draggable => false)
      elsif weight == 3 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window =>info_window_for_biz(business, i) , :icon => @@heat_icon_3, :clickable => false, :draggable => false)
      elsif weight == 2 then
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_2, :clickable => false, :draggable => false)
      else
        heat_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => @@heat_icon_1, :clickable => false, :draggable => false)
      end
      @markers << heat_marker
      new_marker = GMarker.new([business["latitude"], business["longitude"]], :title => business["name"], :info_window => info_window_for_biz(business, i), :icon => restaurant_icon)
      @markers << new_marker
    end	
    #apply the markers
    @markers.each do |marker|
      map.overlay_init(marker)#should change to @map.add_overlay(@marker)
    end
    return map
  end
  
  def self.getEventGMap(events_list)

    #call index function
    first_business = events_list[0]
    map = GMap.new("map_div")
    map.control_init(:large_map => true, :map_type => true)

    map.center_zoom_init([first_business["latitude"], first_business["longitude"]], 12)

    #######################################################
    test_icon = GIcon.new(
      :image => "/images/strike.png",
      :icon_anchor => GPoint.new(16,37),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(test_icon, "test_icon")
    test_icon = Variable.new("test_icon")

    heat_icon = GIcon.new(
      :image => "/images/heat_icon_5.png",
      :icon_anchor => GPoint.new(26,26),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon, "heat_icon")
    heat_icon = Variable.new("heat_icon")
    #######################################################
    #call update function
    # loop through each element and create a GMarker
    @markers = []
    events_list.each_with_index do |event, i|
      heat_marker = GMarker.new([event["latitude"], event["longitude"]], :title => event["title"], :info_window => info_window_for_event(event, i), :icon => heat_icon)
      @markers << heat_marker
      new_marker = GMarker.new([event["latitude"], event["longitude"]], :title => event["title"], :info_window => info_window_for_event(event, i), :icon => test_icon)
      @markers << new_marker
    end	
    #apply the markers
    @markers.each do |marker|
      map.overlay_init(marker)#should change to @map.add_overlay(@marker)
    end

    #@polygons = []
    #business_list.each do |business|
    #  polygon = GPolygon.new(polygon_pts(business["latitude"], business["longitude"]))
    #  polygon.color = "#4CC417"
    #  polygon.weight = 3
    #  polygon.opacity = 0.5
    #  @polygons << polygon
    #end
    #@polygons.each do |polygon|
    #  map.overlay_init(polygon)
    #end

    return map
    #sample1 = GMarker.new([41.023849, -80.682053], :title => 'sampler', :info_bubble => 'sample1')
    #map.overlay_init(sample1)
  end

  #REFACTOR THIS CRAP.
  def self.initialize_heat_icons(map)
  
    heat_icon_15 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_15.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_15, "heat_icon_15")
    @@heat_icon_15 = Variable.new("heat_icon_15")
    
    heat_icon_14 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_14.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_14, "heat_icon_14")
    @@heat_icon_14 = Variable.new("heat_icon_14")
    
    heat_icon_13 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_13.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_13, "heat_icon_13")
    @@heat_icon_13 = Variable.new("heat_icon_13")
    
    heat_icon_12 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_12.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_12, "heat_icon_12")
    @@heat_icon_12 = Variable.new("heat_icon_12")
    
    heat_icon_11 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_11.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_11, "heat_icon_11")
    @@heat_icon_11 = Variable.new("heat_icon_11")
    
    heat_icon_10 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_10.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_10, "heat_icon_10")
    @@heat_icon_10 = Variable.new("heat_icon_10")
    
    heat_icon_9 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_9.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_9, "heat_icon_9")
    @@heat_icon_9 = Variable.new("heat_icon_9")
    
    heat_icon_8 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_8.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_8, "heat_icon_8")
    @@heat_icon_8 = Variable.new("heat_icon_8")
    
    heat_icon_7 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_7.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_7, "heat_icon_7")
    @@heat_icon_7 = Variable.new("heat_icon_7")
    
    heat_icon_6 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_6.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_6, "heat_icon_6")
    @@heat_icon_6 = Variable.new("heat_icon_6")
    
    heat_icon_5 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_5.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_5, "heat_icon_5")
    @@heat_icon_5 = Variable.new("heat_icon_5")
   
    heat_icon_4 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_4.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_4, "heat_icon_4")
    @@heat_icon_4 = Variable.new("heat_icon_4")
  
    heat_icon_3 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_3.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_3, "heat_icon_3")
    @@heat_icon_3 = Variable.new("heat_icon_3")
   
    heat_icon_2 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_2.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_2, "heat_icon_2")
    @@heat_icon_2 = Variable.new("heat_icon_2")
 
    heat_icon_1 = GIcon.new(
      :image => "/images/icons/heat/heat_icon_1.png",
      :icon_anchor => GPoint.new(36,36),
      :info_window_anchor => GPoint.new(9,2)
    )
    map.icon_global_init(heat_icon_1, "heat_icon_1")
    @@heat_icon_1 = Variable.new("heat_icon_1")
  end

end

def info_window_for_biz(biz, i) 
  out = ''
  num = i+1
  out = out + '<div>' + num.to_s + ') ' + biz['name'].to_s + '</div>'
  out = out + '<div>Street Address : ' + biz['address1'].to_s + ', ' + biz['city'].to_s + ', ' + biz['state_code'].to_s + '</div>'
  out = out + '<div>Avg Rating : ' + biz['avg_rating'].to_s + '</div>'
end

def info_window_for_event(event, i) 
  out = ''
  num = i+1
  out = out + '<div>' + num.to_s + ') ' + event['title'].to_s + '</div>'
  out = out + '<div>Street Address : ' + event['venue_address'].to_s + ', ' + event['city_name'].to_s + ', ' + event['region_abbr'].to_s + '</div>'
  out = out + '<div>Start : ' + event['start_time'].to_s + '</div>'
  out = out + '<div>End : ' + event['stop_time'].to_s + '</div>'
end


