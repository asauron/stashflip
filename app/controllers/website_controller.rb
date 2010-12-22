class WebsiteController < ApplicationController
  def index
  	page = params[:page] || 1
	@deals = Deal.paginate(:page=>page, :per_page=>20, :order => 'created_at DESC', :conditions => ['source != ?', 'stashflip'])
  end

  def about
  end
end
