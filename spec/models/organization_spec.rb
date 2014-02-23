require 'spec_helper'

describe Organization do
  it_behaves_like "a model"

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:organization_type) }
  it { should ensure_inclusion_of(:organization_type).in_array(%w(Nonprofit Business Individual)) }

  it { should have_many :field_hosts }
  it { should have_many :projects }
end
