class Api::V1::BaseApiController < ApplicationController
  #  before_action :authenticate_api_v1_user!
  def current_user
    @current_user ||= User.first
  end


end
