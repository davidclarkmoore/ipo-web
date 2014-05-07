require 'spec_helper'

describe StudentApplication do

  context "When complete or important details equal false" do
    before(:each) do 
      stub(subject).complete_or_important_details? {false}
    end
    it_behaves_like "a model"
    it { should validate_presence_of :project_session_id }
  end

  it { should belong_to :project_session }
  it { should belong_to :student }
  it { should accept_nested_attributes_for :student }

  context "Create StudentApplication" do

    it "should set to pending, status and application_status" do
      @student_application = create(:student_application)
      expect(@student_application.status).to eq(StudentApplication::INCOMPLETE)
    end
  end
end
