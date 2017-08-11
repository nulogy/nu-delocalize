module Delocalize
  class Railtie < Rails::Railtie
    initializer "delocalize" do |app|
      ActiveSupport.on_load :active_record do
        if ActiveRecord::VERSION::MAJOR == 4
          require "delocalize/rails_ext/active_record_rails4"
        else
          raise "Unsupported version of ActiveRecord: #{ActiveRecord::VERSION::STRING}"
        end
      end

      ActiveSupport.on_load :action_view do
        if ActionView::VERSION::MAJOR == 4
          require "delocalize/rails_ext/action_view_rails4"
        else
          raise "Unsupported version of ActionView: #{ActionView::VERSION::STRING}"
        end
      end
    end
  end
end