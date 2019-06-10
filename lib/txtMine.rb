require "txtMine/version"
require 'csv'
require 'bundler/setup'
Bundler.require(:default)

module TxtMine
  class Error < StandardError; end
  # Your code goes here...

end

require_relative './constants/stop_words'


require_relative './strategies/strategy'


require_relative './functions.rb'

require_relative './tolkenizer/strategies/punctuation_delimeter_strategy'
require_relative './tolkenizer/strategies/whitespace_delimeter_strategy'
require_relative './tolkenizer/tolkenizer'

require_relative './indexer/indexer'

require_relative './scorer/scorer'