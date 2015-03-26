=begin
ActiveRecord::Base.instance_eval do
  def define_method_attribute=(attr_name)
    if create_time_zone_conversion_attribute?(attr_name, columns_hash[attr_name])
      method_body, line = <<-EOV, __LINE__ + 1
        def #{attr_name}=(original_time)
          time = original_time
          unless time.acts_like?(:time)
            time = time.is_a?(String) ? (I18n.delocalization_enabled? ? Time.zone.parse_localized(time) : Time.zone.parse(time)) : time.to_time rescue time
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
=end

if Gem::Version.new(ActionPack::VERSION::STRING) >= Gem::Version.new('4.0.0.beta')
  require 'delocalize/rails_ext/active_record_rails4'
else
  require 'delocalize/rails_ext/active_record_rails3'
end
