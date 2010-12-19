class Deal < ActiveRecord::Base
	attr_accessor :title, :date, :price
	
	def initialize(title, date, price)
		@title, @date, @price = title, date, price
	end
	
	def to_s
		return "#{@title} published on #{@date} with price #{@price}"
	end
end
