require 'spec_helper'

describe SessionsController do

  describe "GET 'index'" do
    before :each do 
      @sessions = FactoryGirl.create_list(:session, rand(2..10))
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "renders the :index view" do
      get 'index'
      response.should render_template :index
    end

    it "display all the existing sessions" do
      get :index
      sessions = assigns(:sessions).reload
      expect(sessions.count).to eq(Session.all.count)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/new'
    end

    context "With valid attributes" do
      it "saves the new session in database" do
        expect{
          post :create, session: FactoryGirl.attributes_for(:session)
        }.to change(Session, :count).by (1)
      end

      it "redirects to the index page" do
        post :create, session: FactoryGirl.attributes_for(:session)
        response.should redirect_to sessions_path
      end
    end

    context "With unvalid attributes" do  
      it "does not save the new session to the database" do
        expect{
          post :create, session: FactoryGirl.attributes_for(:invalid_session)
        }.to_not change(Session, :count)
      end

      it "renders the form" do
        post :create, session: FactoryGirl.attributes_for(:invalid_session)
        response.should render_template :new
      end
    end
  end

  describe "GET 'show'" do
    it "assigns the request session to @session" do
      session = FactoryGirl.create(:session)
      get :show, id: session.id
      assigns(:session).should eq(session)
    end

    it "renders the show view" do
      get :show, id: FactoryGirl.create(:session)
      response.should render_template :show
    end
  end

  describe "GET 'new'" do
    it "renders the new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @session = FactoryGirl.create(:session)
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/#{@session.id}/edit'
    end

    context "With valid attributes" do
      it "finds the request sesssion" do
        put 'update', id: @session.id, session: FactoryGirl.attributes_for(:session)
        assigns(:session).should eq(@session)
      end

      it "changes @session attributes" do
        put 'update', id: @session.id, session: { title: "new title" }
        @session.reload
        expect(@session.title).to eq("new title")
      end

      it "redirects to session path" do
        put 'update', id: @session.id, session: { title: "new title"}
        response.should redirect_to sessions_path
      end
    end

    context "With unvalid attributes" do
      it "does not change @session attributes" do
        put 'update', id: @session.id, session: { title: "new title", duration: nil }
        @session.reload
        expect(@session.title).to_not eq("new title")
      end

      it "renders the form" do
        put 'update', id: @session.id, session: { title: "new title", duration: nil }
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @session = FactoryGirl.create(:session)
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/sessions/'
    end

    it "deletes the session" do
      expect{
        delete :destroy, id: @session
      }.to change(Session, :count).by(-1)
    end

    it "redirects to the session path" do
      delete :destroy, id: @session
      response.should redirect_to "http://localhost:3000/sessions/"
    end
  end
end
