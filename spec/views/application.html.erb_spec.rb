require 'spec_helper'

describe "layouts/application" do
  it "displays default rails page" do
    render
    expect(rendered).to have_content "IPO Connection"
  end
end