if defined?(Rails::Railtie)
  require 'delocalize/railtie'
elsif defined?(Rails::Initializer)
  raise "This version of delocalize is only compatible with Rails 3.0 or newer"
end

module Delocalize
  class ParserNotFound < ArgumentError; end

  autoload :Parsers, 'delocalize/parsers'

  # this ensures that a subsequent call to `column_for_attribute` will return a column and not nil
  def self.model_has_column?(model, column_name)
    return false unless model.respond_to?(:has_attribute?) && model.has_attribute?(column_name)

    model.class.columns.any? { |e| e.name == column_name }
  end
end
