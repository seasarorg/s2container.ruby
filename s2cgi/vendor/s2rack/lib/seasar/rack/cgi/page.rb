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
      class Page < Seasar::CGI::Page
        @@rack = nil
        class << self

          #
          # - args
          #   - none
          # - return
          #   - Boolean
          #
          def rack?; return @@rack.nil? == false; end

          #
          # - args
          #   1. Proc <em>prc</em>
          # - return
          #   - Proc
          #
          def rack(&prc)
            @@rack = prc if not prc.nil?
            return @@rack
          end

          #
          # - args
          #   1. Object <em>app</em>
          # - return
          #   - Object
          #
          def rackup(app); return @@rack.call(app); end
        end

        #
        # - args
        #   - String
        # - return
        #   - nil
        #
        def script_name
          return @request.script_name
        end

        #
        # - args
        #   1. String <em>str</em>
        # - return
        #   - nil
        #
        def puts(str)
          @response.write(str)
        end

        #
        # - args
        #   1. Object <em>obj</em>
        # - return
        #   - nil
        #
        def p(obj)
          @response.write(obj.inspect)
        end

        #
        # - args
        #   1. Rack::Request <em>request</em>
        # - return
        #   - nil
        #
        def request=(request); @request = request end

        #
        # - args
        #   - none
        # - return
        #   - Rack::Request
        #
        def request; return @request end
        alias req request

        #
        # - args
        #   1. Rack::Response <em>response</em>
        # - return
        #   - nil
        #
        def response=(response); @response = response end

        #
        # - args
        #   - none
        # - return
        #   - Rack::Response
        #
        def response; return @response end
        alias res response

        #
        # - args
        #   1. Hash <em>env</em>
        # - return
        #   - Array status, headers, body
        #
        def call(env)
          @s2cgi_page_id = self.generate_page_id
          @page_id = @s2cgi_page_id
          @env = env
          self.request = ::Rack::Request.new(env)
          self.response = ::Rack::Response.new
          @validate = Seasar::Validate::Context.new
          @tpl_stack = []
          @auto_render = true

          unless ::Rack::MethodOverride::HTTP_METHODS.member?(@request.request_method)
            raise "unsupport request method. [#{@env['rack.methodoverride.original_method']} -> #{@request.request_method}]"
          end

          self.init
          method_name = @request.request_method.downcase.to_sym
          validate_method_name = "validate_#{method_name}"

          validate_result = true
          validators = @@validators[self.class].nil? ? {} : @@validators[self.class]
          if validators.key?(:all)
            validate_result = self.instance_eval(&validators[:all])
          end

          if validate_result == true
            if validators.key?(method_name)
              validate_result = self.instance_eval(&validators[method_name])
            elsif self.respond_to?(validate_method_name)
              validate_result = self.method(validate_method_name).call
            end
            if validate_result == true && self.respond_to?(method_name)
              self.method(method_name).call
            end
          end

          render if @auto_render && @response.body.size == 0 && @response.status == 200
          return self.out
        end

        #
        # - args
        #   - none
        # - return
        #   - Array status, headers, body
        #
        def out
          return @response.finish
        end

        #
        # - args
        #   1. String <em>url</em>
        #   2. Hash <em>params</em>
        # - return
        #   - nil
        #
        def redirect(url, params = {})
          sep = url.index('?').nil? ? '?' : '&'
          items = params.map {|key, val|
            ::Rack::Utils.escape(key) << '=' << ::Rack::Utils.escape(val)
          }
          url << sep << items.join('&') if 0 < items.size 
          self.response = ::Rack::Response.new([], 302, {'Location' => url})
        end

        #
        # - args
        #   1. String <em>str</em>
        # - return
        #   - nil
        #
        def render_result(str)
          @response.write(str)
        end

        #
        # - args
        #   1. Symbol <em>key</em>
        # - return
        #   - Object
        #
        def get_param(key)
          raise TypeError.new('invali rack request instance.') unless @request.is_a?(::Rack::Request)
          return @request.params[key.to_s]
        end

        #
        # - args
        #   - none
        # - return
        #   - CGI::Session|nil
        #
        def get_session
          return Seasar::Rack::Session.get_session(@env)
        end
        alias session get_session

        #
        # - args
        #   - none
        # - return
        #   - CGI::Session
        #
        def start_session
          return Seasar::Rack::Session.start_session(@env)
        end

        #
        # - args
        #   1. CGI::Session <em>session</em>
        # - return
        #   - nil
        #
        def delete_session(session)
          return Seasar::Rack::Session.delete_session(@env, session)
        end
      end
    end
  end
end
