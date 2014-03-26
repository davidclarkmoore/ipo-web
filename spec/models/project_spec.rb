require 'spec_helper'

describe Project do

  it { should belong_to :organization }
  it { should belong_to :field_host }

  let (:project) { Project.new }

  def set_status_and_test(status)
    project.wizard_status = status
    expect(yield).to be_true
  end

  it "#complete? should return true if status == 'complete'" do
    set_status_and_test('complete') { project.complete? }
  end

  it "#complete_or_about_you? should return true if status == 'about_you' or status == 'complete'" do
    project.wizard_status = 'complete'
    expect(project.complete_or_about_you?).to be_true
    project.wizard_status = 'about_you'
    expect(project.complete_or_about_you?).to be_true
  end

  it "#complete_or_the_project? should return true if status = 'the_project' or status == 'complete'" do
    project.wizard_status = 'complete'
    expect(project.complete_or_the_project?).to be_true
    project.wizard_status = 'the_project'
    expect(project.complete_or_the_project?).to be_true
  end

  it "#complete_or_location? should return true if status = 'location' or status == 'complete'" do
    project.wizard_status = 'complete'
    expect(project.complete_or_location?).to be_true
    project.wizard_status = 'location'
    expect(project.complete_or_location?).to be_true
  end

  it "#complete_or_content? should return true if status = 'content' or status == 'complete'" do
    project.wizard_status = 'complete'
    expect(project.complete_or_content?).to be_true
    project.wizard_status = 'content'
    expect(project.complete_or_content?).to be_true
  end

  it "#complete_or_agreement? should return true if status = 'agreement' or status == 'complete'" do
    project.wizard_status = 'complete'
    expect(project.complete_or_agreement?).to be_true
    project.wizard_status = 'agreement'
    expect(project.complete_or_agreement?).to be_true
  end

  it "#get_pretty_properties should return a comma separated list of data" do
    stub(I18n).t { {a: 'a', b: 'b', c: 'c'} }
    expect(project.get_pretty_properties(['a', 'b', 'c'], 'key')).to eq("a, b, c")
  end

end
