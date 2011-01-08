xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Deals"
    xml.description "Best electronics deals"
    xml.link formatted_deals_url(:rss)
    deals = Deal.find(:all, :order => 'publish_date DESC')
    for deal in deals
      xml.item do
      	temp_name = '[PROFIT +'+ number_to_currency(deal.profit_margin, :unit => "$") + '] ' + deal.name
        xml.title temp_name
        xml.description deal.description
        xml.pubDate deal.publish_date.to_s(:rfc822)
        xml.link formatted_deal_url(deal)
        xml.guid formatted_deal_url(deal)
      end
    end
  end
end