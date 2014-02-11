require 'spec_helper'

describe Reference do
  it_behaves_like "a model"

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_numericality_of :phone }
end
