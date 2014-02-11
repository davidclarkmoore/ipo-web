require 'spec_helper'

describe Login do
  it_behaves_like "a model"
  
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:password_confirmation)}
end
