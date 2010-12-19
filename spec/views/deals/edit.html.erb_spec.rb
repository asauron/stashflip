require 'spec_helper'

describe "/deals/edit.html.erb" do
  include DealsHelper

  before(:each) do
    assigns[:deal] = @deal = stub_model(Deal,
      :new_record? => false
    )
  end

  it "renders the edit deal form" do
    render

    response.should have_tag("form[action=#{deal_path(@deal)}][method=post]") do
    end
  end
end
