require 'spec_helper'

describe StudentApplication do
  it_behaves_like "a model"

  it { should validate_presence_of :project_session_id }
  it { should belong_to :project_session}
  it { should belong_to :student }
  it { should accept_nested_attributes_for :student }

  context "Create StudentApplication" do

    it "should set to pending, status and application_status" do
      @student_application = FactoryGirl.create(:student_application)
      expect(@student_application.status).to eq(StudentApplication::PENDING)
      expect(@student_application.application_status).to eq(StudentApplication::PENDING)
    end
  end
end
