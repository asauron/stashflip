desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
	dc = DealsController.new
	dc.post_deal
end
