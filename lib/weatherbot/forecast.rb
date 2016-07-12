module Weatherbot
  Hour = Struct.new(:hour, :temperature, :condition)

  class Forecast
    def initialize(api:, region:, city:)
      @api    = api
      @region = region
      @city   = city
    end

    def hours
      weather_data = api.fetch(region: region, city: city)
      weather_data["hourly_forecast"]
        .select do |hour|
          hour["FCTTIME"]["mday"].to_i == Date.today.day
        end.map do |hour|
          Hour.new(hour["FCTTIME"]["hour"].to_i,
                  hour["temp"]["metric"],
                  hour["condition"])
        end
    end

    private

    attr_reader :api, :region, :city
  end
end
