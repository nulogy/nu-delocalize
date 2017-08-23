if defined?(Rails::Railtie)
  require 'delocalize/railtie'
elsif defined?(Rails::Initializer)
  raise "This version of delocalize is only compatible with Rails 3.0 or newer"
end

module Delocalize
  class ParserNotFound < ArgumentError; end

  autoload :Parsers,                 'delocalize/parsers'
end
