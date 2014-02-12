require 'spec_helper'

describe ProjectSession do
  it_behaves_like "a model"

  it { should validate_presence_of(:project_id) }
  it { should validate_presence_of(:session_id) }
  
  
  it { should belong_to :project }
  it { should belong_to :session }
  it { should have_many(:student_applications) }

  context "Create ProjectSession" do
    it "should set the status to INCOMPLETE" do
      project_session = FactoryGirl.create(:project_session)
      expect(project_session.status).to eq(ProjectSession::INCOMPLETE)
    end

    it "should not allow multiple sessions for the same project" do
      project_session = FactoryGirl.create(:project_session)
      project_session_2 = FactoryGirl.build(:project_session)
      expect(project_session_2).to have(1).errors_on(:session_id)
    end
  end

end
