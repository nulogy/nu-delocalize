module Delocalize
  class ParserNotFound < ArgumentError; end

  autoload :Parsers, 'delocalize/parsers'
end
