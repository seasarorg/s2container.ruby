#
# S2Container initializer for RoR
#
require 's2container'
Seasar::Log::Factory::RubyLoggerFactory.logdev = "#{RAILS_ROOT}/log/s2.log"
s2logger.level = Logger::WARN
s2logger.formatter = Logger::Formatter.new

alias s2component_dist s2component
def s2component(option = {}, &procedure)
  if self.class == Class && self.ancestors.member?(ActionController::Base) && option[:namespace].nil?
    option[:namespace] = self.controller_name
  end
  if self.class == Class && self.ancestors.member?(ActiveRecord::Base) && option[:class].nil? && procedure.nil?
    if self.name.match(/Dao$/)
      option[:class] = Class
      procedure = proc {|cd| self}
      option[:name] = option[:name].nil? ? Seasar::Util::ClassUtil.ub_name(self) : option[:name]
      option[:namespace] =  option[:namespace].nil? ? 'daos' : option[:namespace]
    else
      option[:namespace] =  option[:namespace].nil? ? 'models' : option[:namespace]
    end
  end
  s2component_dist(option, &procedure)
end
alias s2comp s2component

require 'thread'
module S2Rails
  IncludeNamespaces = %w[services daos models interceptors dbi]

  class Rack
    @@mutex = Mutex.new
    def initialize(app); @app = app; end
    def call(env)
      if false == Rails.configuration.cache_classes # and false == $rails_rake_task
        # for the development environment
        @@mutex.synchronize {
          s2app.init(:force => true)
          # see railties/lib/initializer.rb L387
          Rails.configuration.eager_load_paths.each {|load_path|
            matcher = /\A#{Regexp.escape(load_path)}(.*)\.rb\Z/
            Dir.glob("#{load_path}/**/*.rb").sort.each {|file|
              require_dependency(file.sub(matcher, '\1'))
            }
          }
          Thread.current[:S2ApplicationContext] = s2app.snapshot
        }
      end
      @app.call(env)
    end
  end
  ActionController::Dispatcher.middleware.use(S2Rails::Rack)

  module_function
  #
  # - args
  #   1. ActionController::Request <em>request</em>
  # - return
  #   - Seasar::Container::S2Container
  #
  def get_s2container(request)
    ctrl_name = request.path_parameters['controller']
    namespaces = [ctrl_name] + S2Rails::IncludeNamespaces
    if false == Rails.configuration.cache_classes # and false == $rails_rake_task
      container = s2app.create(namespaces)
    else
      container = s2app.create_singleton_container(namespaces)
    end
    return container
  end
end
