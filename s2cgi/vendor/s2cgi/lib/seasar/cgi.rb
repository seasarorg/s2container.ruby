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
  module CGI
    autoload :Page, 'seasar/cgi/page'
    autoload :Session, 'seasar/cgi/session'

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
        if container.component_def?(Seasar::CGI::Page)
          page = container.get(Seasar::CGI::Page)
        else
          page = Seasar::CGI::Page.new
        end
      elsif comp.is_a?(Class) || comp.is_a?(Symbol) || comp.is_a?(String)
        page = s2app.create.get(comp)
      else
        page = comp
      end

      begin
        page.call
      rescue => e
        if Seasar::CGI::Page.fatal?
          Seasar::CGI::Page.fatal.call(e, page)
        else
          s2logger.fatal(self) {"#{e.message} #{e.backtrace}"}
        end
      end
    end
  end
end