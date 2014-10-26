require 'spec_helper'

describe "Lessions" do
  describe "GET /lessions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get lessions_path
      response.status.should be(200)
    end
  end
end
