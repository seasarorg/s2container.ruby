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
  module GAE
    class Page < Seasar::Rack::CGI::Page
      @@tpl_dir = File.join(ROOT_DIR, 'tpl')
      @@tpl_ext = 'rhtml'

      #
      # - args
      #   - none
      # - return
      #   - org.mortbay.jetty.servlet.HashSessionManager$Session
      #
      def get_session
        return nil if @env['java.servlet_request'].session.new?
        return @env['java.servlet_request'].session
      end
      alias session get_session

      #
      # - args
      #   - none
      # - return
      #   - org.mortbay.jetty.servlet.HashSessionManager$Session
      #
      def start_session
        self.delete_session
        return @env['java.servlet_request'].session
      end

      #
      # - args
      #   - none
      # - return
      #   - nil
      #
      def delete_session
        @env['java.servlet_request'].session.invalidate unless @env['java.servlet_request'].session.new?
      end
    end
  end
end
