require 'spec_helper'

describe "lessions/show" do
  before(:each) do
    @lession = assign(:lession, stub_model(Lession,
      :title => "Title",
      :description => "MyText",
      :video => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
