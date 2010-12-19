# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def form_field_maker (form, field, title, size=HTML_TEXT_LENGTH, maxlength=DATABASE_STRING_LENGTH)
		label = content_tag("label", "#{title}:", :for => field)
		form_field = form.text_field field, :size => size, :maxlength => maxlength
		content_tag("div", "#{label} #{form_field}", :class => "form_row")
	end

end
