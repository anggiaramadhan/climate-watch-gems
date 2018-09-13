require 'active_support/concern'

module ClimateWatchEngine
  module Caching
    extend ActiveSupport::Concern

    included do
      before_action :set_caching_headers
    end

    private

    # rubocop:disable Naming/AccessorMethodName
    def set_caching_headers
      return true if Rails.env.development?
      expires_in 2.hours, public: true
    end
    # rubocop:enable Naming/AccessorMethodName
  end
end
