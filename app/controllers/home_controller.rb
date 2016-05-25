class HomeController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate
end
