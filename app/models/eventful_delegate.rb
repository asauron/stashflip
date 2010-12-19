class EventfulDelegate < ActiveRecord::Base
  require 'rubygems'
  require 'eventful/api'

  @EVENTFUL_API_KEY = "X6tW4dH4sbz73p7s"

  @eventful = Eventful::API.new @EVENTFUL_API_KEY
  def self.generate_search_params(mapfilter)
#http://api.eventful.com/rest/events/search?AUTHENTIFICATION&keywords=books&location=San+Diego&date=Future
#http://api.eventful.com/rest/events/search?app_key=X6tW4dH4sbz73p7s&keywords=books&location=San+Diego&date=Future
    
    query = mapfilter.query.gsub(/\s+/, '+')
    location = mapfilter.location.gsub(/\s+/, '+')
    params = {
      :keywords => query,
      :location => location,
      :page_size => 15
    }
    #@search_string = 'http://api.eventful.com/rest/events/search?' + 'app_key=' + @EVENTFUL_API_KEY + '&keywords='+ query +'&location=' + location + '&date=Future'

  end
  def self.search_by_filter(mapfilter)
    results = @eventful.call('events/search', generate_search_params(mapfilter))
    
    if results['events'].nil? then
      nil
    else
      results['events']['event']
    end
  end
end
