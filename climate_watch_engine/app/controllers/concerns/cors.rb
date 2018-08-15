require 'active_support/concern'

module Cors
  extend ActiveSupport::Concern

  included do
    before_action :set_access_control_headers
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = ENV['CORS_WHITELIST']
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Expose-Headers'] = 'Link, Total, Per-Page'
  end
end
