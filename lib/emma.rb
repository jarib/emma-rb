require 'childprocess'
require 'nokogiri'
require 'tempfile'

require "emma/version"
require 'emma/control'
require 'emma/report'

module Emma
  class Error < StandardError
  end
end
