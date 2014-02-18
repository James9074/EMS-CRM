class SessionsControllerController < Devise::SessionsController
  skip_before_filter :require_login
end
