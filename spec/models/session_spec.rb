require 'spec_helper'

describe Session do
  subject { FactoryGirl.create(:session) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:duration) }

  it { should have_many(:project_sessions) }

  context "Create a new Session" do
    it "should set the deadline 60 days from the current date" do
      session = FactoryGirl.create(:session)
      expect(session.application_deadline).to eq(Date.today + 60.days)
    end

    it "should not allow multiple sessions for the same period" do
      session = FactoryGirl.create(:session, start_date: Date.today, end_date: Date.today + 1.month)

      session_2 = FactoryGirl.build(:session, start_date: Date.today, end_date: Date.today + 1.month)
      expect(session_2).to have(1).errors_on(:start_date)
    end
  end
end
