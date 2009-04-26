#
# S2Container initializer for RoR
#
require 's2container'
Seasar::Log::S2Logger.logdev = "#{RAILS_ROOT}/log/s2.log"
s2logger.level = Logger::DEBUG
s2logger.formatter = Logger::Formatter.new

alias s2component_dist s2component
def s2component(option = {}, &procedure)
  if self.class == Class && self.ancestors.member?(ActionController::Base) && option[:namespace].nil?
      option[:namespace] = self.controller_name
  end
  s2component_dist(option, &procedure)
end
alias s2comp s2component

require 'thread'
module S2Rails
  IncludeNamespaces = %w[services daos models interceptors dbi]

  class Rack
    @@mutex = Mutex.new
    @@s2app = nil
    def initialize(app); @app = app; end
    def call(env)
      if false == Rails.configuration.cache_classes # and false == $rails_rake_task
        # for the development environment
        @@mutex.synchronize {
          s2app.init(:force => true)
          # see railties/lib/initializer.rb L387
          Rails.configuration.eager_load_paths.each do |load_path|
            matcher = /\A#{Regexp.escape(load_path)}(.*)\.rb\Z/
            Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
              require_dependency file.sub(matcher, '\1')
            end
          end
          env[:s2app] = s2app.snapshot
        }
      else
        # for the production environment
        @@s2app ||= s2app.snapshot
        env[:s2app] = @@s2app
      end
      s2app.init(:force => true)
      @app.call(env)
    end
  end
  ActionController::Dispatcher.middleware.use(S2Rails::Rack)

  module_function
  #
  # - args
  #   1. ActionController::Request <em>request</em>
  # - return
  #   - Seasar::Container::S2Container|nil
  #
  def get_s2container(request)
    s2app = request.env[:s2app]
    return nil if s2app.nil?
    ctrl_name = request.path_parameters['controller']
    return  s2app.create([ctrl_name] + S2Rails::IncludeNamespaces)
  end
end
