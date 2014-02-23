require 'spec_helper'

describe DashboardsController do

  describe "Fieldhost Dashboard" do

    before(:each) do
      fieldhost = create(:field_host)
      login = create(:login, entity_type: "FieldHost", entity_id: fieldhost.id)
      sign_in login
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end 

  describe "Student Dashboard" do

    before(:each) do
      student = create(:student)
      login = create(:login, entity_type: "Student", entity_id: student.id)
      sign_in login
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

end
