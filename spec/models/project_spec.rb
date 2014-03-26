require 'spec_helper'

describe Project do

  it { should belong_to :organization }
  it { should belong_to :field_host }

  let (:project) { Project.new }

  def test_with_status(status)
    project.wizard_status = status
    expect(yield).to be_true
  end

  it "#complete? should return true if status == 'complete'" do
    test_with_status('complete') { project.complete? }
  end

  it "#complete_or_about_you? should return true if status == 'about_you' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_about_you? }
    test_with_status('about_you') { project.complete_or_about_you? }
  end

  it "#complete_or_the_project? should return true if status = 'the_project' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_the_project? }
    test_with_status('the_project') { project.complete_or_the_project? }
  end

  it "#complete_or_location? should return true if status = 'location' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_location? }
    test_with_status('location') { project.complete_or_location? }
  end

  it "#complete_or_content? should return true if status = 'content' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_content? }
    test_with_status('content') { project.complete_or_content? }
  end

  it "#complete_or_agreement? should return true if status = 'agreement' or status == 'complete'" do
    test_with_status('complete') { project.complete_or_agreement? }
    test_with_status('agreement') { project.complete_or_agreement? }
  end

  it "#get_pretty_properties should return a comma separated list for a key in locale" do
    stub(I18n).t { {a: 'a', b: 'b', c: 'c'} }
    expect(project.get_pretty_properties(['a', 'b', 'c'], 'key')).to eq("a, b, c")
  end

end
