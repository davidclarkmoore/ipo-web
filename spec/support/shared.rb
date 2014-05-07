

# ---- SHARED EXAMPLES ---- #
shared_examples_for "a model" do
  it { should be_invalid } # Because of email validation etc
  context "when built with a default complete factory" do
    subject { FactoryGirl.create(described_class.name.underscore.to_sym) }
    it { should be_valid }
  end
end