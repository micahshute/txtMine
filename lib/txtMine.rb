require "txtMine/version"

module TxtMine
  class Error < StandardError; end
  # Your code goes here...
end

require_relative './constants/stop_words'


require_relative './strategies/strategy'


require_relative './tolkenizer/strategies/punctuation_delimeter_strategy'
require_relative './tolkenizer/strategies/whitespace_delimeter_strategy'
require_relative './tolkenizer'