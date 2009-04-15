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
    module Session
      @@options = {}

      module_function

      #
      # - args
      #   1. Hash <em>options</em>
      # - return
      #   - nil
      #
      def options=(options)
        @@options = options
      end

      #
      # - args
      #   1. CGI <em>cgi</em>
      # - return
      #   - CGI::Session|nil
      #
      def get_session(cgi)
        begin
          return ::CGI::Session.new(cgi, @@options.merge({"new_session" => false}))
        rescue ArgumentError => e
          s2logger.info(self){"session has not been started."}
          s2logger.debug(self){"#{e.message} #{e.backtrace}"}
          return nil
        end
      end

      #
      # - args
      #   1. CGI <em>cgi</em>
      # - return
      #   - CGI::Session
      #
      def start_session(cgi)
        session = ::CGI::Session.new(cgi, @@options.merge({"new_session" => true}))
        return session
      end

    end
  end
end
