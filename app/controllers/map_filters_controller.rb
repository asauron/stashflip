class MapFiltersController < ApplicationController
  # GET /map_filters
  # GET /map_filters.xml
  def index
    @map_filters = MapFilter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @map_filters }
    end
  end

  # GET /map_filters/1
  # GET /map_filters/1.xml
  def show
    @map_filter = MapFilter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @map_filter }
    end
  end

  # GET /map_filters/new
  # GET /map_filters/new.xml
  def new
    @map_filter = MapFilter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @map_filter }
    end
  end

  # GET /map_filters/1/edit
  def edit
    @map_filter = MapFilter.find(params[:id])
  end

  # POST /map_filters
  # POST /map_filters.xml
  def create
    @map_filter = MapFilter.new(params[:map_filter])

    respond_to do |format|
      if @map_filter.save
        format.html { redirect_to(@map_filter, :notice => 'MapFilter was successfully created.') }
        format.xml  { render :xml => @map_filter, :status => :created, :location => @map_filter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @map_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /map_filters/1
  # PUT /map_filters/1.xml
  def update
    @map_filter = MapFilter.find(params[:id])

    respond_to do |format|
      if @map_filter.update_attributes(params[:map_filter])
        format.html { redirect_to(@map_filter, :notice => 'MapFilter was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @map_filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /map_filters/1
  # DELETE /map_filters/1.xml
  def destroy
    @map_filter = MapFilter.find(params[:id])
    @map_filter.destroy

    respond_to do |format|
      format.html { redirect_to(map_filters_url) }
      format.xml  { head :ok }
    end
  end
end
