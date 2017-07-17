module Delocalize
  class Railtie < Rails::Railtie
    initializer "delocalize" do |app|
      ActiveSupport.on_load :active_record do
        if Gem::Version.new(ActionPack::VERSION::STRING) >= Gem::Version.new('4.0.0.beta')
          require 'delocalize/rails_ext/active_record_rails4'
        else
          require 'delocalize/rails_ext/active_record_rails3'
        end
      end

      ActiveSupport.on_load :action_view do
        if Gem::Version.new(ActionPack::VERSION::STRING) >= Gem::Version.new('4.0.0.beta')
          require 'delocalize/rails_ext/action_view_rails4'
        else
          require 'delocalize/rails_ext/action_view_rails3'
        end
      end

      require 'delocalize/rails_ext/time_zone'
    end
  end
end