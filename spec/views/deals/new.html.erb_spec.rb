require 'spec_helper'

describe "/deals/new.html.erb" do
  include DealsHelper

  before(:each) do
    assigns[:deal] = stub_model(Deal,
      :new_record? => true
    )
  end

  it "renders new deal form" do
    render

    response.should have_tag("form[action=?][method=post]", deals_path) do
    end
  end
end
