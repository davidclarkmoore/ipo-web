include Devise::TestHelpers

include Warden::Test::Helpers
Warden.test_mode!

# Will run the given code as the user passed in
def as_user(user=nil, &block)
  current_login = user.login || Factory.create(:user)
  as_login(:user, current_login, &block)
end

def as_admin(admin=nil, &block)
  current_login = admin.login || Factory.create(:admin)
  as_login(:admin, current_login)
end

def as_login(scope = :user, login=nil, &block)
  if request.present?
    sign_in(login)
  else
    Rails.logger.info "as_login login_as #{login}"
    login_as(login, :scope => scope, :run_callbacks => false)
  end
  block.call if block.present?
  return self
end

def as_visitor(user=nil, &block)
  current_login = user.login || Factory.stub(:user)
  if request.present?
    sign_out(current_login)
  else
    logout(:user)
  end
  block.call if block.present?
  return self
end

RSpec.configure do |config|
  config.after(:each) { Warden.test_reset! }
end