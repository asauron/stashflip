class Deal < ActiveRecord::Base
	attr_accessor :title, :date, :price
	
	def to_s
		return "#{@title} #{@description}"
	end
end
