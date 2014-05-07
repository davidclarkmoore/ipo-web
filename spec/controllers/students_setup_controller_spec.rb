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

  %w(about_you interests_and_fields_of_study 
    important_details confirmation).each do |step| 
    describe "GET '#show #{step}'" do
      it "returns http success" do
        get :show, id: step
        response.should be_success
      end

      it 'renders the #{step} template' do
        get :show, id: step
        response.should render_template(step)
      end
    end
  end
  
  before(:each) do
      @project = create(:completed_projects)
      @session = create(:session)
      @project_session = ProjectSession.create(session_id: @session.id, project_id: @project.id)
  end
  
  describe "PUT '#update student application step: about_you" do
    context "when valid attributes" do
      it "creates a student" do
        expect {
          put :update, id: 'about_you', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student),
          }
        }.to change(Student, :count)
      end

      it "redirects to next step: interests_and_fields_of_study" do
        put :update, id: 'about_you', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student),
          }
        response.should redirect_to subject.send(:wizard_path, :interests_and_fields_of_study)
      end
    end

    context "when invalid attributes" do
      
      it "does not creates a student" do
        expect {
          put :update, id: 'about_you', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:invalid_student),
          }
        }.to_not change(Student, :count)
      end

      it "redirects to the same step: about_you" do
        put :update, id: 'about_you', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:invalid_student),
          }
        response.should render_template("about_you")
      end
    end
  end

  describe "PUT '#update student application step: about_you" do
    
    context "when valid attributes" do
      it "updates the student_application" do
        put :update, id: 'interests_and_fields_of_study', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student_for_interests_and_field_of_study_step)
            }, is_new_spiritual_reference: true, is_new_academic_reference: true
          assigns(:student_application).student.passions.should =~ ["Children at Risk", "Drug Abuse"] 
          assigns(:student_application).student.overall_education.should eq("High School Graduate")
          assigns(:student_application).student.graduation_year.should eq("2013")
      end

      it "redirects to the next step: important_details" do
        put :update, id: 'interests_and_fields_of_study', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student_for_interests_and_field_of_study_step)
            }, is_new_spiritual_reference: true, is_new_academic_reference: true
        response.should redirect_to subject.send(:wizard_path, :important_details)
      end
    end

    context "when invalid attributes" do
      it "does not update student_application" do
        put :update, id: 'interests_and_fields_of_study', your_project_select: nil, 
          student_application: { 
            student_attributes: FactoryGirl.attributes_for(:invalid_student_for_interests_and_field_of_study_step)
          }, is_new_spiritual_reference: true, is_new_academic_reference: true
        assigns(:student_application).student.passions.should be_empty
        assigns(:student_application).student.overall_education.should eq(nil)
        assigns(:student_application).student.graduation_year.should eq(nil)
      end

      it "redirects to the same step: interests_and_fields_of_study" do
        put :update, id: 'interests_and_fields_of_study', your_project_select: nil, 
          student_application: { 
            student_attributes: FactoryGirl.attributes_for(:invalid_student_for_interests_and_field_of_study_step)
          }, is_new_spiritual_reference: true, is_new_academic_reference: true
        response.should render_template("interests_and_fields_of_study")
      end
    end

  end

  describe "PUT '#update student application step: important_details" do
    
    context "when valid attributes" do
      it "updates the student_application" do
        put :update, id: 'important_details', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student_for_interests_and_field_of_study_step),
            agree_terms: 1
            }, is_new_spiritual_reference: true, is_new_academic_reference: true
          assigns(:student_application).agree_terms.should be_true
      end

      it "redirects to the next step: confirmation" do
        put :update, id: 'important_details', your_project_select: @project.id, 
          student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student_for_interests_and_field_of_study_step),
            agree_terms: 1
            }, is_new_spiritual_reference: true, is_new_academic_reference: true
        response.should redirect_to subject.send(:wizard_path, :confirmation)
      end
    end

    context "when invalid attributes" do
      it "does not update student_application" do
        put :update, id: 'important_details', your_project_select: @project.id, 
           student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student_for_interests_and_field_of_study_step),
            agree_terms: 0
            }, is_new_spiritual_reference: true, is_new_academic_reference: true
        assigns(:student_application).agree_terms.should be_false
        
      end

      it "redirects to the same step: important_details" do
        put :update, id: 'important_details', your_project_select: @project.id, 
           student_application: { 
            project_session_id: @project_session.id,
            student_attributes: FactoryGirl.attributes_for(:student_for_interests_and_field_of_study_step),
            agree_terms: 0
            }, is_new_spiritual_reference: true, is_new_academic_reference: true
        response.should render_template("important_details")
      end
    end

  end

#important_details
#"student_application"=>{"agree_terms"=>"1"}

end
