class Deal < ActiveRecord::Base
	validates_presence_of :name, :description, :guid, :source, :buy_link, :cost, :cost_retail, :profit_margin
	validates_numericality_of :cost, :cost_retail, :profit_margin
	
	has_attached_file :photo,	:url  => "/assets/deals/:id/:style/:basename.:extension",
                  				:path => ":rails_root/public/assets/deals/:id/:style/:basename.:extension"
 	
	def to_s
		return "#{@title} #{@description}"
	end
end
