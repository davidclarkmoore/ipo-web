require 'spec_helper'

describe Project do
  it { should belong_to :organization }
  it { should belong_to :field_host }
end
