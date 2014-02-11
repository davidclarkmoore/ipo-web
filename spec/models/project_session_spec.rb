require 'spec_helper'

describe ProjectSession do
  it_behaves_like "a model"

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:project_id) }
  
  it { should belong_to :project}
end
