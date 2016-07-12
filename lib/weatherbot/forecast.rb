require "date"

module Weatherbot
  Hour = Struct.new(:hour, :temperature, :feels_like, :dew_point, :condition, :wind_speed, :cloud_cover, :snow?, :chance_of_rain)

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
                   hour["temp"]["metric"].to_i,
                   hour["feelslike"]["metric"].to_i,
                   hour["dewpoint"]["metric"].to_i,
                   hour["condition"],
                   hour["wspd"]["metric"].to_i,
                   hour["sky"].to_i,
                   hour["snow"]["metric"].to_i > 0,
                   hour["pop"].to_i)
        end
    end

    private

    attr_reader :api, :region, :city
  end
end
