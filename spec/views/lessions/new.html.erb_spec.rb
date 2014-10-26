require 'spec_helper'

describe "lessions/new" do
  before(:each) do
    assign(:lession, stub_model(Lession,
      :title => "MyString",
      :description => "MyText",
      :video => "MyText"
    ).as_new_record)
  end

  it "renders new lession form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", lessions_path, "post" do
      assert_select "input#lession_title[name=?]", "lession[title]"
      assert_select "textarea#lession_description[name=?]", "lession[description]"
      assert_select "textarea#lession_video[name=?]", "lession[video]"
    end
  end
end
