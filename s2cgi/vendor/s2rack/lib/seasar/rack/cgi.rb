# -*- coding: utf-8 -*-
#--
# +----------------------------------------------------------------------+
# | Copyright 2005-2008 the Seasar Foundation and the Others.            |
# +----------------------------------------------------------------------+
# | Licensed under the Apache License, Version 2.0 (the "License");      |
# | you may not use this file except in compliance with the License.     |
# | You may obtain a copy of the License at                              |
# |                                                                      |
# |     http://www.apache.org/licenses/LICENSE-2.0                       |
# |                                                                      |
# | Unless required by applicable law or agreed to in writing, software  |
# | distributed under the License is distributed on an "AS IS" BASIS,    |
# | WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                        |
# | either express or implied. See the License for the specific language |
# | governing permissions and limitations under the License.             |
# +----------------------------------------------------------------------+
#++

module Seasar
  module Rack
    module CGI
      module_function

      #
      # - args
      #   1. Seasar::CGI::Page|String|Symbol|nil <em>comp</em>
      # - return
      #   - nil
      #
      def run(comp = nil)
        if comp.nil?
          container = s2app.create
          if container.component_def?(Seasar::Rack::CGI::Page)
            app = container.get(Seasar::Rack::CGI::Page)
          else
            app = Seasar::Rack::CGI::Page.new
          end
        elsif comp.is_a?(Class) || comp.is_a?(Symbol) || comp.is_a?(String)
          app = s2app.create.get(comp)
        else
          app = comp
        end
        if block_given?
          app = yield(app)
        elsif Seasar::Rack::CGI::Page.rack?
          app = Seasar::Rack::CGI::Page.rackup(app)
        end
        begin
          ::Rack::Handler::CGI.run(app)
        rescue => e
          if Seasar::Rack::CGI::Page.fatal?
            Seasar::Rack::CGI::Page.fatal.call(e, app)
          else
            s2logger.fatal(self) {"#{e.message} #{e.backtrace}"}
          end
        end

        begin
          container.destroy if container
        rescue => e
          s2logger.error(self) {"destroy of s2container failed. #{e.message} #{e.backtrace}"}
        end
      end

    end
  end
end
