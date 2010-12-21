class DealsController < ApplicationController
  # GET /deals
  # GET /deals.xml
  def index
    @deals = Deal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deals }
    end
  end

  # GET /deals/1
  # GET /deals/1.xml
  def show
    @deal = Deal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deal }
    end
  end

  # GET /deals/new
  # GET /deals/new.xml
  def new
    @deal = Deal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deal }
    end
  end

  # GET /deals/1/edit
  def edit
    @deal = Deal.find(params[:id])
  end

  # POST /deals
  # POST /deals.xml
  def create
    @deal = Deal.new(params[:deal])

    respond_to do |format|
      if @deal.save
        format.html { redirect_to(@deal, :notice => 'Deal was successfully created.') }
        format.xml  { render :xml => @deal, :status => :created, :location => @deal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deals/1
  # PUT /deals/1.xml
  def update
    @deal = Deal.find(params[:id])

    respond_to do |format|
      if @deal.update_attributes(params[:deal])
        format.html { redirect_to(@deal, :notice => 'Deal was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  # DELETE /deals/1.xml
  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy

    respond_to do |format|
      format.html { redirect_to(deals_url) }
      format.xml  { head :ok }
    end
  end
  
  def post_deal 	  
  	  @passwird_delegate = PasswirdDelegate.new  	  
  	  @latest_deals = BensbargainsDelegate.get_breaking_news(200)
  	  @latest_deals = @latest_deals + PasswirdDelegate.get_breaking_news(200)
  	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved and Description contains [Compare] or Next lowest price on, then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? && DealAdapter.contains_price_comparison(latest_deal)
  	   		latest_deal.save
  	   	end
  	  end
  	  
	  redirect_to :root, :notice => "Posted new deal. ~~~~~~ #{@latest_deals[0].to_s}"
  end
end
