class FavoriteMapsController < ApplicationController
  # GET /favorite_maps
  # GET /favorite_maps.xml
  def index
    @favorite_maps = FavoriteMap.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @favorite_maps }
    end
  end

  # GET /favorite_maps/1
  # GET /favorite_maps/1.xml
  def show
    @favorite_map = FavoriteMap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @favorite_map }
    end
  end

  # GET /favorite_maps/new
  # GET /favorite_maps/new.xml
  def new
    @favorite_map = FavoriteMap.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @favorite_map }
    end
  end

  # GET /favorite_maps/1/edit
  def edit
    @favorite_map = FavoriteMap.find(params[:id])
  end

  # POST /favorite_maps
  # POST /favorite_maps.xml
  def create
    @favorite_map = FavoriteMap.new(params[:favorite_map])

    respond_to do |format|
      if @favorite_map.save
        format.html { redirect_to(@favorite_map, :notice => 'FavoriteMap was successfully created.') }
        format.xml  { render :xml => @favorite_map, :status => :created, :location => @favorite_map }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @favorite_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /favorite_maps/1
  # PUT /favorite_maps/1.xml
  def update
    @favorite_map = FavoriteMap.find(params[:id])

    respond_to do |format|
      if @favorite_map.update_attributes(params[:favorite_map])
        format.html { redirect_to(@favorite_map, :notice => 'FavoriteMap was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @favorite_map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /favorite_maps/1
  # DELETE /favorite_maps/1.xml
  def destroy
    @favorite_map = FavoriteMap.find(params[:id])
    @favorite_map.destroy

    respond_to do |format|
      format.html { redirect_to(favorite_maps_url) }
      format.xml  { head :ok }
    end
  end
end
