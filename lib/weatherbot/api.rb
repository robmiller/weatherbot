require "net/http"
require "uri"
require "json"

module Weatherbot
  class APIError < WeatherbotException; end
  class JSONError < WeatherbotException; end

  class API
    def initialize(api_key:)
      @api_key = api_key
    end

    def fetch(region:, city:)
      json = fetch_json(region, city)
      parse_json(json)
    end

    private

    attr_reader :api_key

    def fetch_json(region, city)
      uri = URI.parse("http://api.wunderground.com/api/#{api_key}/hourly/q/#{region}/#{city}.json")

      response = Net::HTTP.get_response(uri)
      fail "API returned a non-200 response" unless response.code == "200"

      response.body
    rescue Object => e
      raise APIError, "Couldn't fetch the JSON from the API: #{e.message}"
    end

    def parse_json(json)
      JSON.parse(json)
    rescue Object => e
      fail Weatherbot::JSONError, "Couldn't parse the API response: #{e.message}"
    end
  end
end
