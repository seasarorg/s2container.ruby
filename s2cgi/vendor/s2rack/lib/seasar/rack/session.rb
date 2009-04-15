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

module Rack
  class Request
    def key?(key)
      return self.params[key].nil? == false
    end
  end
end

module Seasar
  module Rack
    module Session
      @@key = '_session_id'
      @@options = {}

      module_function

      #
      # - args
      #   1. String <em>key</em>
      # - return
      #   - nil
      #
      def key=(key)
        @@key = key
      end

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
      #   1. Hash <em>env</em>
      # - return
      #   - CGI::Session|nil
      #
      def get_session(env)
        if env["rack.session"][@@key].nil? then return nil end

        request = ::Rack::Request.new(env)
        request[@@key] = env["rack.session"][@@key]
        begin
          return ::CGI::Session.new(request, @@options)
        rescue ArgumentError => e
          env["rack.session"][@@key] = nil
          s2logger.info(self){"#{e.message} #{e.backtrace}"}
          return nil
        end
      end

      #
      # - args
      #   1. Hash <em>env</em>
      # - return
      #   - CGI::Session
      #
      def start_session(env)
        request = ::Rack::Request.new(env)
        session = ::CGI::Session.new(request, @@options.merge({"new_session" => true}))
        env["rack.session"][@@key] = request.instance_variable_get(:@output_cookies)[0][0]
        return session
      end

      #
      # - args
      #   1. Hash <em>env</em>
      #   2. CGI::Session <em>session</em>
      # - return
      #   - nil
      #
      def delete_session(env, session)
        env["rack.session"][@@key] = nil
        session.delete
      end
    end
  end
end
