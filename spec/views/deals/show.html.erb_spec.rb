require 'spec_helper'

describe "/deals/show.html.erb" do
  include DealsHelper
  before(:each) do
    assigns[:deal] = @deal = stub_model(Deal)
  end

  it "renders attributes in <p>" do
    render
  end
end
