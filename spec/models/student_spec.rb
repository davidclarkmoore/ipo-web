require 'spec_helper'

describe Student do
  it_behaves_like "a model"

  it { should have_one :login }
  it { should belong_to :academic_reference }
  it { should belong_to :spiritual_reference }
  it { should have_many :student_applications }
  it { should have_many(:projects).through(:student_applications) }

  it { should accept_nested_attributes_for :login }
  it { should accept_nested_attributes_for :academic_reference }
  it { should accept_nested_attributes_for :spiritual_reference }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:gender) }
  it { should validate_presence_of(:marital_status) }
  it { should validate_presence_of(:street_address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:postal_code) }
  it { should validate_presence_of(:preferred_phone) }
  it { should validate_presence_of(:organization) }
  it { should validate_presence_of(:birthday) }
  it { should validate_presence_of(:heard_about_ipo) }
  it { should validate_numericality_of(:graduation_year) }
end
