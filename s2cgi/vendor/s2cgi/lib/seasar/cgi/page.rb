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
    class Page
      ACCEPTABLE_METHODS = [:GET, :POST]
      @@fatal = nil
      @@tpl_dir = nil
      @@tpl_ext = 'html'
      @@validators = {}
      class << self

        #
        # - args
        #   - none
        # - return
        #   - Boolean
        #
        def fatal?; @@fatal.nil? == false; end

        #
        # - args
        #   1. Proc <em>prc</em>
        # - return
        #   - Proc
        #
        def fatal(&prc)
          @@fatal = prc unless prc.nil?
          return @@fatal
        end

        #
        # - args
        #   - none
        # - return
        #   - String
        #
        def tpl_dir; return @@tpl_dir; end

        #
        # - args
        #   1. String <em>dir</em>
        # - return
        #   - nil
        #
        def tpl_dir=(dir); return @@tpl_dir = dir; end

        #
        # - args
        #   - none
        # - return
        #   - String
        #
        def tpl_ext; return @@tpl_ext; end

        #
        # - args
        #   1. String <em>ext</em>
        # - return
        #   - nil
        #
        def tpl_ext=(ext); return @@tpl_ext = ext; end

        #
        # - args
        #   1. Symbol <em>method</em>
        #   2. Proc <em>procedure</em>
        # - return
        #   - nil
        #
        def validate(method = :all, &procedure)
          @@validators[method.to_s.downcase.to_sym] = procedure
        end
      end

      attr_accessor :cgi
      
      #
      # - args
      #   - none
      # - return
      #   - String
      #
      def script_name
        return ENV['SCRIPT_NAME']
      end

      #
      # - args
      #   1. String <em>str</em>
      # - return
      #   - nil
      #
      def puts(str)
        @contents << str << "\n"
      end

      #
      # - args
      #   1. Object <em>obj</em>
      # - return
      #   - nil
      #
      def p(obj)
        @contents << obj.inspect << "\n"
      end

      #
      # - args
      #   - none
      # - return
      #   - nil
      #
      def init; end

      #
      # - args
      #   - none
      # - return
      #   - nil
      #
      def call
        @s2cgi_page_id = self.generate_page_id
        @cgi ||= ::CGI.new
        @validate = Seasar::Validate::Context.new
        @headers = {}
        @contents = ''
        @auto_render = true
        @auto_response = true
        @tpl_stack = []

        raise "unsupport request method. [#{@cgi.request_method}]" unless ACCEPTABLE_METHODS.member?(@cgi.request_method.to_sym)

        self.init

        method_name = @cgi.request_method.downcase.to_sym
        validate_method_name = "validate_#{method_name}"

        validate_result = true
        if @@validators.key?(:all)
          validate_result = self.instance_eval(&@@validators[:all])
        end

        if validate_result == true
          if @@validators.key?(method_name)
            validate_result = self.instance_eval(&@@validators[method_name])
          elsif self.respond_to?(validate_method_name)
            validate_result = self.method(validate_method_name).call
          end
          if validate_result == true && self.respond_to?(method_name)
            self.method(method_name).call
          end
        end
        render if @auto_render && @contents.size == 0
        if @auto_response
          self.out
        end
      end

      #
      # - args
      #   - none
      # - return
      #   - String|nil
      #
      def generate_page_id
        require 'securerandom'
        begin
          return SecureRandom.hex(16)
        rescue NotImplementedError
          s2logger.warn(self) {"SecureRandom unavailable."}
        end
        return nil
      end

      #
      # - args
      #   - none
      # - return
      #   - nil
      #
      def out
        @cgi.out(@headers){@contents}
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
          ::CGI.escape(key.to_s) << '=' << ::CGI.escape(val.to_s)
        }
        url << sep << items.join('&') if 0 < items.size 
        print @cgi.header('status' => 'REDIRECT', 'Location' => url)
        exit
      end

      #
      # - args
      #   1. String <em>template</em>
      # - return
      #   - nil
      #
      def render(template = nil)
        template = self.get_default_tpl if template.nil?
        @template = self.normalize_tpl(template)
        @layout = self.get_layout(@template)
        __tpl__ = @layout.nil? ? @template : @layout
        @tpl_stack.push(__tpl__.gsub(/\W/, '_'))
        result = ::ERB.new(File.read(self.get_tpl_file(__tpl__)), nil, nil,  's2cgi_' + @tpl_stack.join('_')).result(binding)
        @tpl_stack.pop
        self.render_result(result)
      end

      #
      # - args
      #   1. String <em>str</em>
      # - return
      #   - nil
      #
      def render_result(str)
        @contents << str
      end

      #
      # - args
      #   1. String <em>template</em>
      # - return
      #   - String
      #
      def partial(template)
        template = self.normalize_tpl(template)
        @tpl_stack.push(template.gsub(/\W/, '_'))
        result = ::ERB.new(File.read(self.get_tpl_file(template)), nil, nil, 's2cgi_' + @tpl_stack.join('_')).result(binding)
        @tpl_stack.pop
        return result
      end

      #
      # - args
      #   - none
      # - return
      #   - String
      #
      def get_default_tpl
        return self.script_name.sub(/^#{BASE_URL}\//, '').sub(/\..+?$/, '')
      end

      #
      # - args
      #   1. String <em>tpl</em>
      # - return
      #   - String
      #
      def get_tpl_file(tpl)
        return File.join(@@tpl_dir, tpl + '.' + @@tpl_ext)
      end

      #
      # - args
      #   1. String <em>tpl</em>
      # - return
      #   - nil|String
      #
      def get_layout(tpl)
        layout = "#{tpl}_layout"
        return layout if File.exists?(self.get_tpl_file(layout))

        items = tpl.split(/\//)
        items.pop
        items << 'layout'
        layout = File.join(*items)
        return layout if File.exists?(self.get_tpl_file(layout))

        return "layout" if File.exists?(self.get_tpl_file("layout"))

        return nil
      end

      #
      # - args
      #   1. String <em>tpl</em>
      # - return
      #   - String
      #
      def normalize_tpl(tpl)
        t = tpl.sub(/\.[^\.]+?$/, '')
        t.tr!('.', '')
        t.tr!('\\', '/')
        t.gsub!(/^\/+/, '')
        t.gsub!(/\/+$/, '')
        t.gsub!(/\/+/, '/')
        raise "invalid template [#{tpl}]." if t == ''
        return t
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      #   3. Hash <em>options</em>
      # - return
      #   - nil|String|Array
      #
      def param(name, type = nil, options = nil)
        if type.nil?
          self.get_param(name)
        else
          self.validate_param(name, type, options)
        end
      end

      #
      # - args
      #   1. Symbol <em>key</em>
      # - return
      #   - nil|String|Array
      #
      def get_param(key)
        raise TypeError.new('invali cgi instance.') unless @cgi.is_a?(::CGI)
        val = @cgi.params[key.to_s]
        case val.size
        when 0
          return nil
        when 1
          return val[0]
        else
          return val
        end
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      #   3. Hash <em>options</em>
      # - return
      #   - nil
      #
      def validate_param(name, type, options = nil)
        @validate.register(name, type, self.get_param(name), options)
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Boolean
      #
      def valid?(name = nil, type = nil)
        return @validate.valid?(name, type)
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Boolean
      #
      def error?(name = nil, type = nil)
        return @validate.error?(name, type)
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Array
      #
      def valids(name = nil, type = nil)
        return @validate.valids(name, type)
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      # - return
      #   - Array
      #
      def errors(name = nil, type = nil)
        return @validate.errors(name, type)
      end

      #
      # - args
      #   1. Symbol <em>name</em>
      #   2. Symbol <em>type</em>
      #   3. Proc
      # - return
      #   - nil
      #
      def if_errors(name = nil, type = nil)
        if self.error?(name, type)
          yield self.errors(name, type)
        end
      end
       
      #
      # - args
      #   - none
      # - return
      #   - CGI::Session|nil
      #
      def get_session
        return Seasar::CGI::Session.get_session(@cgi)
      end
      alias session get_session
      
      #
      # - args
      #   - none
      # - return
      #   - CGI::Session
      #
      def start_session
        return Seasar::CGI::Session.start_session(@cgi)
      end

    end
  end
end

