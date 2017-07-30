ENV['RACK_ENV'] = 'test'

require './boot'
require 'byebug'
require './spec/helpers/board_helper'

RSpec.configure do |config|
  config.include Helpers
end
