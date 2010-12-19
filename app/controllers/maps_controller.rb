class MapsController < ApplicationController
  # GET /maps
  # GET /maps.xml
  def index
    @maps = Map.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @maps }
    end
  end

  # GET /maps/1
  # GET /maps/1.xml
  def show
    @map = Map.find(params[:id])
    @mapfilter = @map.map_filter # MapFilter.find(:first, :conditions => {:map_id => @map.id})
    @map_owner = User.find(:first, :conditions => {:id => [@map.user_id]})
    if @mapfilter.category == 'events'
      @events_list = EventfulDelegate.search_by_filter(@mapfilter)
    else
      #need to refactor this code into show 1 place only
      @business_list = YelpDelegate.search_by_filter(@mapfilter) #search by filter instead of just city
    end
    if (@business_list != nil && !@business_list.empty?)
      #see if yelp ran out of max 100 api calls/day
      #@query = @business_list[0]
      #put in a filter
      @displaymap = GmapDelegate.getGMap(@business_list)
    elsif @events_list != nil && !@events_list.empty?

      @displaymap = GmapDelegate.getEventGMap(@events_list)
    else
		redirect_to :root, :notice => 'Error loading map.' and return false
    end
 	
    respond_to do |format|
     format.html # show.html.erb
     format.xml  { render :xml => @displaymap }
    end
  end

  # GET /maps/new
  # GET /maps/new.xml
  def new
    @map = Map.new(params[:map])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @map }
    end
  end

  # GET /maps/1/edit
  def edit
    @map = Map.find(params[:id])
  end

  # POST /maps
  # POST /maps.xml
  def create
    @map = Map.new(params[:map])

    respond_to do |format|
      if @map.save
        format.html { redirect_to(@map, :notice => 'Map was successfully created.') }
        format.xml  { render :xml => @map, :status => :created, :location => @map }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /maps/1
  # PUT /maps/1.xml
  def update
    @map = Map.find(params[:id])

    respond_to do |format|
      if @map.update_attributes(params[:map])
        format.html { redirect_to(@map, :notice => 'Map was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1
  # DELETE /maps/1.xml
  def destroy
    @map = Map.find(params[:id])
    @map.destroy

    respond_to do |format|
      format.html { redirect_to(maps_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
    @map = Map.new
    @map.title = "firstmap"
    @mapfilter = MapFilter.new
    #@mapfilter.map_id = @map
    @mapfilter.query = params[:query]
    @mapfilter.location = params[:location]  	
    @mapfilter.num_ratings_weight = params[:num_ratings_weight]
    @mapfilter.avg_rating_weight = params[:avg_rating_weight]
    @mapfilter.cheapness_weight = params[:cheapness_weight]
    @mapfilter.add_nodes = ""
    @mapfilter.exclude_nodes = ""
    #@mapfilter.category = "Restaurants"
    @mapfilter.category = MapFilter.getCategory(params)
    
    #debugging variables
    @query = params[:query]
    @location = params[:location]
    @category = @mapfilter.category    
    @num_ratings_weight = params[:num_ratings_weight]
    @avg_rating_weight = params[:avg_rating_weight]
	@cheapness_weight = params[:cheapness_weight]
			
	if @mapfilter.category == 'events'
      @events_list = EventfulDelegate.search_by_filter(@mapfilter)
    else
      #need to refactor this code into show 1 place only
      @business_list = YelpDelegate.search_by_filter(@mapfilter) #search by filter instead of just city
    end
    
    if params[:query]=='' || params[:location]==''
		redirect_to :root, :notice => 'You must fill in query and location.'
    elsif (@business_list != nil && !@business_list.empty?)
      #see if yelp ran out of max 100 api calls/day
      #@query = @business_list[0]
      #put in a filter
      @displaymap = GmapDelegate.getGMap(@business_list)
    elsif @events_list != nil && !@events_list.empty?
     
      @displaymap = GmapDelegate.getEventGMap(@events_list)
    else
      redirect_to :root, :notice => 'Search returned no results. Try searching again.'
    end
  end

  def save
    @map = Map.new
    @map.user_id = params[:map_user_id]
    @map.title = params[:map_title]
    @map.permission = params[:map_permission]
    @mapfilter = MapFilter.new
    @mapfilter.query = params[:map_query]
    @mapfilter.location = params[:map_location]
    @mapfilter.category = params[:map_category]
    @mapfilter.add_nodes = params[:map_add]
    @mapfilter.exclude_nodes = params[:map_exclude]
    @mapfilter.num_ratings_weight = [:map_num_ratings_weight]
    @mapfilter.avg_rating_weight = [:map_avg_rating_weight]
    @mapfilter.cheapness_weight = [:map_cheapness_weight]
    @map.save
    #must save to get a map id then can set filter id
    @mapfilter.map_id = @map.id
    @mapfilter.save
    redirect_to privateprofile_url
  end

  def save_favorite
    @favorite_map = FavoriteMap.new
    @favorite_map.user_id = params[:user_id]
    @favorite_map.map_id = params[:map_id]
    #check to only save if we do not have this map already
    if FavoriteMap.find(:first, :conditions => {:user_id => params[:user_id], :map_id => params[:map_id]}).nil?
      @favorite_map.save
      redirect_to privateprofile_url, :notice => 'Map saved to your favorites'
    else
      redirect_to privateprofile_url, :notice => 'Map is already in your favorites'
    end
  end

  def rate
    @map = Map.find(params[:id])
    @map.rate(params[:stars], current_user, params[:dimension])
    render :update do |page|
      page.replace_html @map.wrapper_dom_id(params), ratings_for(@map, params.merge(:wrap => false))
      page.visual_effect :highlight, @map.wrapper_dom_id(params)
    end
  end
  
  def add
    @map = Map.find(params[:map_id])
    @mapfilter = @map.map_filter
    if @mapfilter.add_nodes .eql? ''
      @mapfilter.add_nodes = params[:add]
    else
      @mapfilter.add_nodes = @mapfilter.add_nodes + ", " + params[:add]
    end
    @mapfilter.save
    redirect_to '/maps/' + @map.id.to_s
  end
  
  def exclude
    @map = Map.find(params[:map_id])
    @mapfilter = @map.map_filter
    if @mapfilter.exclude_nodes .eql?  ''
      @mapfilter.exclude_nodes = params[:exclude]
    else
      @mapfilter.exclude_nodes = @mapfilter.exclude_nodes + ", " + params[:exclude]
    end
    @mapfilter.save
    redirect_to '/maps/' + @map.id.to_s
  end

end
