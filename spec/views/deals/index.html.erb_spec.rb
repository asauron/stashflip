require 'spec_helper'

describe "/deals/index.html.erb" do
  include DealsHelper

  before(:each) do
    assigns[:deals] = [
      stub_model(Deal),
      stub_model(Deal)
    ]
  end

  it "renders a list of deals" do
    render
  end
end
