class WeatherbotException < StandardError; end

require "pathname"

require_relative "weatherbot/api"
require_relative "weatherbot/forecast"
