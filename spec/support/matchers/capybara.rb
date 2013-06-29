RSpec::Matchers.define :have_following_content do |*expected_contents|
  match do |actual|
    expected_contents.all?{|content| actual.has_content? content}
  end
end