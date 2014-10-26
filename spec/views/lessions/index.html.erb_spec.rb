require 'spec_helper'

describe "lessions/index" do
  before(:each) do
    assign(:lessions, [
      stub_model(Lession,
        :title => "Title",
        :description => "MyText",
        :video => "MyText"
      ),
      stub_model(Lession,
        :title => "Title",
        :description => "MyText",
        :video => "MyText"
      )
    ])
  end

  it "renders a list of lessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
