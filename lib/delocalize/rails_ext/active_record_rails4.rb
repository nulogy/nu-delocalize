require 'active_record'

# let's hack into ActiveRecord a bit - everything at the lowest possible level, of course, so we minimalize side effects
ActiveRecord::ConnectionAdapters::Column.class_eval do
  def date?
    klass == Date
  end

  def time?
    klass == Time
  end
end

module ActiveRecord::AttributeMethods::Write
  def type_cast_attribute_for_write(column, value)
    return value unless column

    value = Delocalize::Parsers::Number.new.parse(value) if column.number?
    column.type_cast_for_write value
  end
end

ActiveRecord::Base.class_eval do
  def write_attribute_with_localization(attr_name, original_value)
    new_value = original_value
    if Delocalize.model_has_column?(self, attr_name.to_s)
      column = column_for_attribute(attr_name.to_s)

      if column.date?
        new_value = Delocalize::Parsers::Number.new.parse(original_value) rescue original_value
      elsif column.time?
        new_value = Delocalize::Parsers::DateTime.new(original_value.class).parse(original_value) rescue original_value
      end
    end
    write_attribute_without_localization(attr_name, new_value)
  end
  alias_method_chain :write_attribute, :localization

  # In Rails 4.1.16, _field_changed?(attr, old, value)
  # In Rails 4.2.8,  _field_changed?(attr, old)
  if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR < 2
    define_method :_field_changed? do |attr, old, value|
      if Delocalize.model_has_column?(self, attr)
        column = column_for_attribute(attr)

        if column.number? && column.null && (old.nil? || old == 0) && value.blank?
          # For nullable numeric columns, NULL gets stored in database for blank (i.e. '') values.
          # Hence we don't record it as a change if the value changes from nil to ''.
          # If an old value of 0 is set to '' we want this to get changed to nil as otherwise it'll
          # be typecast back to 0 (''.to_i => 0)
          value = nil
        elsif column.number?
          value = column.type_cast(Delocalize::Parsers::Number.new.parse(value))
        else
          value = column.type_cast(value)
        end
      end

      old != value
    end
  else # Rails 4.2+
    define_method :_field_changed? do |attr, old_value|
      delocalized_old_value = old_value

      if Delocalize.model_has_column?(self, attr)
        column = column_for_attribute(attr)

        if column.number?
          delocalized_old_value = Delocalize::Parsers::Number.new.parse(old_value) rescue old_value
        end
      end

      @attributes[attr].changed_from?(delocalized_old_value)
    end
  end

  def define_method_attribute=(attr_name)
    if create_time_zone_conversion_attribute?(attr_name, columns_hash[attr_name])
      method_body, line = <<-EOV, __LINE__ + 1
        def #{attr_name}=(original_time)
          time = original_time
          unless time.acts_like?(:time)
            time = time.is_a?(String) ? Delocalize::Parsers::DateTime.new(time.class).parse(time) : time.to_time rescue time
          end
          time = time.in_time_zone rescue nil if time
          write_attribute(:#{attr_name}, original_time)
          @attributes_cache["#{attr_name}"] = time
        end
      EOV
      generated_attribute_methods.module_eval(method_body, __FILE__, line)
    else
      super
    end
  end
end
