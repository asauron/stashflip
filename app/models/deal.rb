class Deal < ActiveRecord::Base
	validates_presence_of :name, :description, :guid, :source, :buy_link, :cost, :cost_retail, :profit_margin
	validates_numericality_of :cost, :cost_retail, :profit_margin
  	
	def to_s
		return "#{@title} #{@description}"
	end
end
