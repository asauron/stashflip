xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Deals"
    xml.description "Best electronics deals"
    xml.link formatted_deals_url(:rss)
    
    for deal in Deal.all
      xml.item do
        xml.title deal.name
        xml.description deal.description
        xml.pubDate deal.publish_date
        xml.link formatted_deal_url(deal)
        xml.guid formatted_deal_url(deal)
        xml.stashflip_status deal.stashflip_status
        xml.cost deal.cost
        xml.cost_retail deal.cost_retail
        xml.profit_margin deal.profit_margin
      end
    end
  end
end