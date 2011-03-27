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
	  #post_deal_1
	  #post_deal_2
	  #post_deal_3
	  #post_deal_4
	  #post_deal_5
	  #post_deal_6	
	  post_deal_7  	  	  	  
  	      	  
	  redirect_to :root, :notice => "Deals have been refreshed!"    
  end
  
  def post_deal_1
	  @latest_deals = BfadsDelegate.get_breaking_news
	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? 
  	   		latest_deal.save
  	   	end
  	  end
  end
  
  def post_deal_2
  	  @latest_deals = DealnewslaptopDelegate.get_breaking_news
  	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved and dealnews laptop has a profit then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? && latest_deal.profit_margin>0
  	   		latest_deal.save
  	   	end
  	  end 
  end
  
  def post_deal_3
  	  @latest_deals = DealnewsnetbookDelegate.get_breaking_news
  	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved and dealnews laptop has a profit then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? && latest_deal.profit_margin>0
  	   		latest_deal.save
  	   	end
  	  end 
  end
    
  def post_deal_4
  	  @latest_deals = DealnewsvideogamesDelegate.get_breaking_news
  	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil?
  	   		latest_deal.save
  	   	end
  	  end  	     	
  end
  
  def post_deal_5
   	  @latest_deals = DealnewshdtvDelegate.get_breaking_news
  	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved and dealnews hdtv has a profit then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? && latest_deal.profit_margin>0
  	   		latest_deal.save
  	   	end
  	  end    	  
  end

  def post_deal_6
   	  @latest_deals = DealnewsmonitorDelegate.get_breaking_news
  	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved and dealnews hdtv has a profit then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil? && latest_deal.profit_margin>0
  	   		latest_deal.save
  	   	end
  	  end    	  
  end
    
  def post_deal_7
  	  @latest_deals = CheapgamedealsDelegate.get_breaking_news
	  @latest_deals.map do |latest_deal|
  	  	#If Deal is not already saved then save it
  	  	if Deal.find_by_guid(latest_deal.guid).nil?
  	   		latest_deal.save
  	   	end
  	  end  	
  end
  
  def delete_old_deals
	  # This script deletes all posts that are over 1 week old
	  deal_ids = Deal.find(:all, :conditions => ["created_at < ? and permadeal = ?", 7.days.ago, 'no'])
	
	  if deal_ids.size > 0
	    Deal.destroy(deal_ids)
	  end
	  
	  redirect_to :root, :notice => "#{deal_ids.size} deals have been deleted!"
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
