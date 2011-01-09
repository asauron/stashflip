class DealsController < ApplicationController
  before_filter :ensure_authenticated, :only => [:new, :edit, :create, :update, :destroy]
  
  # GET /deals
  # GET /deals.xml
  def index
    @deals = Deal.all

	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'publish_date DESC')
	
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
  	  @latest_deals1 = BfadsDelegate.get_breaking_news(200)
  	  @latest_deals2 = DealnewsDelegate.get_breaking_news(200) 	  
  	  
  	  @latest_deals1.map do |latest_deal|
  	  	#If Deal is not already saved then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? 
  	   		latest_deal.save
  	   	end
  	  end
  	  
  	  @latest_deals2.map do |latest_deal|
  	  	#If Deal is not already saved and dealnews laptop has a profit then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? && latest_deal.profit_margin>0
  	   		latest_deal.save
  	   	end
  	  end  	  
  	  
	  redirect_to :root    
  end
  
  def mark_stash
  	Deal.update_all(["stashflip_status=?", "stash"], :id => params[:deal_ids])
  	params[:deal_ids]
  	redirect_to deals_path
  end

  def mark_flip
  	Deal.update_all(["stashflip_status=?", "flip"], :id => params[:deal_ids])
  	params[:deal_ids]
  	redirect_to deals_path
  end
  
  def mark_none
  	Deal.update_all(["stashflip_status=?", "none"], :id => params[:deal_ids])
  	params[:deal_ids]
  	redirect_to deals_path
  end  
  
  def mark_permadeal
  	Deal.update_all(["permadeal=?", "yes"], :id => params[:deal_ids])
  	params[:deal_ids]
  	redirect_to deals_path
  end 
  
  def mark_permadeal_remove
  	Deal.update_all(["permadeal=?", "no"], :id => params[:deal_ids])
  	params[:deal_ids]
  	redirect_to deals_path
  end     
end
