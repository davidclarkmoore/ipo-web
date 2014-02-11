require 'spec_helper'

describe Project do
  it_behaves_like "a model"

  it { should belong_to :organization }
  it { should belong_to :field_host }
end
