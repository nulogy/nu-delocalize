module Delocalize
  class Railtie < Rails::Railtie
    initializer "delocalize" do |app|
      ActiveSupport.on_load :active_record do
        ar_version = ActiveRecord::VERSION::STRING

        if Delocalize::Railtie.between_versions?(ar_version, "4.0.0.beta", "5.0.0.beta")
          require "delocalize/rails_ext/active_record_rails4"
        else
          raise "Unsupported version of ActiveRecord: #{ar_version}"
        end
      end

      ActiveSupport.on_load :action_view do
        av_version = ActionView::VERSION::STRING

        if Delocalize::Railtie.between_versions?(av_version, "4.0.0.beta", "5.0.0.beta")
          require "delocalize/rails_ext/action_view_rails4"
        else
          raise "Unsupported version of ActionView: #{av_version}"
        end
      end
    end

    def self.between_versions?(version, minimum_version, exclusive_maximum_version)
      (Gem::Version.new(minimum_version)...Gem::Version.new(exclusive_maximum_version)).cover?(Gem::Version.new(minimum_version))
    end
  end
end