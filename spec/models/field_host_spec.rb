require 'spec_helper'

describe FieldHost do
  it_behaves_like "a model"

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:preferred_phone) }
  it { should validate_presence_of(:phone_type) }
  it { should validate_numericality_of(:years_associated_with_organization) }
  it { should ensure_inclusion_of(:salutation).in_array(%w(Mr. Ms. Dr. Prof. Rev.)) }
  it { should ensure_inclusion_of(:phone_type).in_array(%w(Work Household Mobile Other)) }

  it { should belong_to :organization }
  it { should have_many :projects}
end
