class WebsiteController < ApplicationController
  def index
  	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'publish_date DESC', :conditions => ['source != ?', 'stashflip'])
  end

  def about
  end
  
  def stashindex
  	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'publish_date DESC', :conditions => ['stashflip_status = ?', 'stash'])  	
  end
  
  def flipindex
  	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'publish_date DESC', :conditions => ['stashflip_status = ?', 'flip'])  	
  end
  
  def laptopindex
  	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'publish_date DESC', :conditions => ['source = ?', 'dealnewslaptop'])  	
  end
  
  def videogamesindex
  	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'publish_date DESC', :conditions => ['source != ? and source != ? and category = ?', 'stashflip', 'cheapgamedeals', 'videogame']) 	
  end  

  def hdtvindex
  	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'publish_date DESC', :conditions => ['source = ?', 'dealnewshdtv'])  	
  end    
    
end
