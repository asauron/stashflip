class MapFilter < ActiveRecord::Base
  def self.getCategory(params)
    #default's nothing. no specified category.
    categ = ''
    #check if restaurant's on
    if params[:restaurants] != nil
      categ = categ + 'restaurants' + '+'
    end
    #check if event's on
    if params[:events] != nil
      #categ = categ + 'eventservices'
      categ = categ + 'events' + '+'
    end
    #check if shopping's on
    if params[:shopping] != nil
      categ = categ + 'shopping' + '+'
    end
    #check if nightlife's on
    if params[:nightlife] != nil
      categ = categ + 'nightlife' + '+'
    end
    #check if it ends with +
    if categ.split('').last == '+'
      categ = categ.chop
    end
    return categ
  end
end
