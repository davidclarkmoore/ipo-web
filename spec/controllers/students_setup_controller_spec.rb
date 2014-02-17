require 'spec_helper'

describe StudentsSetupController do

  before(:each) do
    signin
  end
  
  describe "GET 'index'" do
    it "redirects to first step" do
      get 'index'
      response.should redirect_to students_setup_path('about_you')
    end
  end

  describe "GET '#show about_you'" do
    it "returns http success" do
      get :show, id: 'about_you'
      response.should be_success
    end

    it 'renders the about_you template' do
      get :show, id: 'about_you'
      response.should render_template("about_you")
    end
  end

end
