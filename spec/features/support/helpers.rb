module HelperMethods
  def wait_up_to(secs = 2, &block)
    temp = Capybara.default_wait_time
    Capybara.default_wait_time = secs
    block.call
    Capybara.default_wait_time = temp
  end
end
RSpec.configuration.include HelperMethods, :type => :feature