require 'capybara/poltergeist'
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true)
end
Capybara.javascript_driver = :poltergeist
Capybara.always_include_port = true

module CapybaraHelpers
  def url_for_subdomain subdomain="www", path="/"
    port = Capybara.server_port.blank? ? '' : (":" + Capybara.server_port)
    "http://#{subdomain}.lvh.me#{port}#{path}"
  end
end
RSpec.configuration.include CapybaraHelpers, :type => :feature
RSpec.configuration.include CapybaraHelpers, :type => :routing
RSpec.configuration.include CapybaraHelpers, :type => :request