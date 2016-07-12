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
      File.read(Pathname(__dir__) + ".." + ".." + "sample.json")
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
