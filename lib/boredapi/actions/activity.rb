# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'rack'

module Boredapi
  module Actions
    class Activity
      def initialize(base_url, opts = {})
        @base_url = base_url

        @query = {
          type: opts[:type],
          participants: opts[:participants],
          minprice: opts[:price_min],
          maxprice: opts[:price_max],
          minaccessibility: opts[:accessibility_min],
          maxaccessibility: opts[:accessibility_max]
        }.delete_if { |_, value| value.nil? }
      end

      def call
        uri = URI(@base_url)

        uri.query = Rack::Utils.build_query(@query) unless @query.empty?

        response = Net::HTTP.get_response(uri).body

        JSON.parse(response)
      end
    end
  end
end
